class AddTodoValidators {
  static final RegExp _titleRegExp = RegExp(
    r'.*?',
  );
  static final RegExp _descriptionRegExp = RegExp(
    r'.*?',
  );


  static isValidTitle(String title) {
    return _titleRegExp.hasMatch(title) && title.isNotEmpty;
  }

  static isValidDescription(String description) {
    return _descriptionRegExp.hasMatch(description) && description.isNotEmpty;
  }
}
