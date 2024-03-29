class LoginValidators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  static final RegExp _passwordRegExp = RegExp(
    r'.*?',
  );

  static isValidEmail(String email) {
    return _emailRegExp.hasMatch(email) && email.isNotEmpty;
  }

  static isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password) && password.isNotEmpty;
  }
}
