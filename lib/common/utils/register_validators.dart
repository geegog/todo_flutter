class RegisterValidators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  static final RegExp _passwordRegExp = RegExp(
    r'.*?',
  );
  static final RegExp _phoneRegExp = RegExp(
    r'.*?',
  );
  static final RegExp _nameRegExp = RegExp(
    r'.*?',
  );
  static final RegExp _changePasswordRegExp = RegExp(
    r'.*?',
  );

  static isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }

  static isValidPhone(String phone) {
    return _phoneRegExp.hasMatch(phone);
  }

  static isValidName(String name) {
    return _nameRegExp.hasMatch(name);
  }

  static isValidConfirmPassword(String password, String confirmPassword) {
    return _changePasswordRegExp.hasMatch(confirmPassword) && isPasswordEqual(password, confirmPassword);
  }

  static isPasswordEqual(String password, String confirmPassword) {
    return password == confirmPassword;
  }
}
