class AddCategoryValidators {
  static final RegExp _nameRegExp = RegExp(
    r'.*?',
  );


  static isValidName(String name) {
    return _nameRegExp.hasMatch(name) && name.isNotEmpty;
  }
}
