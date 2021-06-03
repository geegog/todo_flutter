import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:todo_flutter/authentication/bloc.dart';
import 'package:todo_flutter/common/domain/repository/user_repository.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final _userRepository = new UserRepository();

  AuthenticationBloc() : super(Uninitialized());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = _userRepository.hasValidToken();
      if (isSignedIn) {
        final user = _userRepository.getUser();
        yield Authenticated(user);
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    yield Authenticated(_userRepository.getUser());
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    _userRepository.signOut();
    yield Unauthenticated();
  }
}
