import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_flutter/common/bloc/login/login_event.dart';
import 'package:todo_flutter/common/bloc/login/login_state.dart';
import 'package:todo_flutter/common/domain/repository/user_repository.dart';
import 'package:todo_flutter/common/utils/login_validators.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final _userRepository = UserRepository();

  @override
  LoginState get initialState => LoginState.empty();

  @override
  Stream<LoginState> transformEvents(
    Stream<LoginEvent> events,
    Stream<LoginState> Function(LoginEvent event) next,
  ) {
    final observableStream = events as Observable<LoginEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! EmailChanged && event is! PasswordChanged);
    });
    final debounceStream = observableStream.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super
        .transformEvents(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
        email: event.email,
        password: event.password,
      );
    }
  }

  Stream<LoginState> _mapEmailChangedToState(String email) async* {
    yield currentState.update(
      isEmailValid: LoginValidators.isValidEmail(email),
    );
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    yield currentState.update(
      isPasswordValid: LoginValidators.isValidPassword(password),
    );
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState({
    String email,
    String password,
  }) async* {
    yield LoginState.loading();
    try {
      final response =
          await _userRepository.authenticate(email: email, password: password);
      Map<String, dynamic> responseObj = json.decode(response);

      if (responseObj['jwt'] != null) {
        _userRepository.persistToken(responseObj['jwt']);
        await _userRepository.persistUser(responseObj['jwt']);
        yield LoginState.success();
      }
      if (responseObj['errors'] != null) {
        yield LoginState.failure();
      }
      if (responseObj['error'] != null) {
        yield LoginState.failure();
      }
    } catch (_) {
      yield LoginState.failure();
    }
  }
}
