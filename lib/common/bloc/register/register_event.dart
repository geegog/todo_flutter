import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class RegisterEvent extends Equatable {
  RegisterEvent([List props = const []]) : super(props);
}

class EmailChanged extends RegisterEvent {
  final String email;

  EmailChanged({@required this.email}) : super([email]);

  @override
  String toString() => 'EmailChanged { email :$email }';
}

class NameChanged extends RegisterEvent {
  final String name;

  NameChanged({@required this.name}) : super([name]);

  @override
  String toString() => 'NameChanged { name :$name }';
}

class PhoneChanged extends RegisterEvent {
  final String phone;

  PhoneChanged({@required this.phone}) : super([phone]);

  @override
  String toString() => 'PhoneChanged { phone :$phone }';
}

class PasswordChanged extends RegisterEvent {
  final String confirmPassword;
  final String password;

  PasswordChanged({@required this.password, @required this.confirmPassword}) : super([password]);

  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class ConfirmPasswordChanged extends RegisterEvent {
  final String confirmPassword;
  final String password;

  ConfirmPasswordChanged({@required this.confirmPassword, @required this.password})
      : super([confirmPassword]);

  @override
  String toString() =>
      'ConfirmPasswordChanged { confirmPassword: $confirmPassword, password: $password }';
}

class Submitted extends RegisterEvent {
  final String email;
  final String password;

  Submitted({@required this.email, @required this.password})
      : super([email, password]);

  @override
  String toString() {
    return 'Submitted { email: $email, password: $password }';
  }
}

class RegisterButtonPressed extends RegisterEvent {
  final String email;
  final String password;
  final String phone;
  final String confirmPassword;
  final String name;

  RegisterButtonPressed(
      {@required this.email,
      @required this.password,
      @required this.phone,
      @required this.name,
      @required this.confirmPassword})
      : super([email, password, phone, name, confirmPassword]);

  @override
  String toString() {
    return 'RegisterButtonPressed { email: $email, password: $password, phone: $phone, name: $name, confirmPassword: $confirmPassword }';
  }
}
