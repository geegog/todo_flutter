import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_flutter/common/bloc/register/bloc.dart';
import 'package:todo_flutter/common/domain/repository/user_repository.dart';
import 'package:todo_flutter/common/utils/register_validators.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final _userRepository = UserRepository();

  @override
  RegisterState get initialState => RegisterState.empty();

  @override
  Stream<RegisterState> transformEvents(
    Stream<RegisterEvent> events,
    Stream<RegisterState> Function(RegisterEvent event) next,
  ) {
    final observableStream = events as Observable<RegisterEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! EmailChanged &&
          event is! PasswordChanged &&
          event is! PhoneChanged &&
          event is! NameChanged &&
          event is! ConfirmPasswordChanged);
    });
    final debounceStream = observableStream.where((event) {
      return (event is EmailChanged ||
          event is PasswordChanged ||
          event is PhoneChanged ||
          event is NameChanged ||
          event is ConfirmPasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super
        .transformEvents(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is PhoneChanged) {
      yield* _mapPhoneChangedToState(event.phone);
    } else if (event is NameChanged) {
      yield* _mapNameChangedToState(event.name);
    } else if (event is ConfirmPasswordChanged) {
      yield* _mapConfirmPasswordChangedToState(
          event.confirmPassword, event.password);
    } else if (event is RegisterButtonPressed) {
      yield* _mapRegisterButtonPressedToState(
        email: event.email,
        password: event.password,
        phone: event.phone,
        confirmPassword: event.confirmPassword,
        name: event.name,
      );
    }
  }

  Stream<RegisterState> _mapEmailChangedToState(String email) async* {
    yield currentState.update(
      isEmailValid: RegisterValidators.isValidEmail(email),
    );
  }

  Stream<RegisterState> _mapPasswordChangedToState(String password) async* {
    yield currentState.update(
      isPasswordValid: RegisterValidators.isValidPassword(password),
    );
  }

  Stream<RegisterState> _mapPhoneChangedToState(String phone) async* {
    yield currentState.update(
      isPasswordValid: RegisterValidators.isValidPhone(phone),
    );
  }

  Stream<RegisterState> _mapNameChangedToState(String name) async* {
    yield currentState.update(
      isPasswordValid: RegisterValidators.isValidName(name),
    );
  }

  Stream<RegisterState> _mapConfirmPasswordChangedToState(
      String password, String confirmPassword) async* {
    yield currentState.update(
      isPasswordValid:
          RegisterValidators.isValidConfirmPassword(password, confirmPassword),
    );
  }

  Stream<RegisterState> _mapRegisterButtonPressedToState({
    String email,
    String password,
    String phone,
    String confirmPassword,
    String name,
  }) async* {
    yield RegisterState.loading();
    try {
      final response = await _userRepository.register(
          email: email,
          password: password,
          phone: phone,
          confirmPassword: confirmPassword,
          name: name);
      Map<String, dynamic> responseObj = json.decode(response);

      if (responseObj['data'] != null) {
        yield RegisterState.success();
      }
      if (responseObj['errors'] != null) {
        yield RegisterState.failure();
      }
      if (responseObj['error'] != null) {
        yield RegisterState.failure();
      }
    } catch (_) {
      yield RegisterState.failure();
    }
  }
}
