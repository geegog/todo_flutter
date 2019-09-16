class RegisterValidators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  static final RegExp _passwordRegExp = RegExp(
    r'.*?',
  );
  static final RegExp _phoneRegExp = RegExp(
    r'^[0-9]',
  );
  static final RegExp _nameRegExp = RegExp(
    r'.*?',
  );
  static final RegExp _changePasswordRegExp = RegExp(
    r'.*?',
  );

  static isValidEmail(String email) {
    return _emailRegExp.hasMatch(email) && email.isNotEmpty;
  }

  static isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password) &&
        password.isNotEmpty &&
        password.length >= 8;
  }

  static isValidPhone(String phone) {
    return _phoneRegExp.hasMatch(phone) && phone.isNotEmpty;
  }

  static isValidName(String name) {
    return _nameRegExp.hasMatch(name) && name.isNotEmpty;
  }

  static isValidConfirmPassword(String password, String confirmPassword) {
    return _changePasswordRegExp.hasMatch(confirmPassword) &&
        isPasswordEqual(password, confirmPassword);
  }

  static isPasswordEqual(String password, String confirmPassword) {
    return password == confirmPassword;
  }
}
