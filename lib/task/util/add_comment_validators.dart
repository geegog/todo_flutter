class AddCommentValidators {
  static final RegExp _textRegExp = RegExp(
    r'.*?',
  );


  static isValidText(String text) {
    return _textRegExp.hasMatch(text) && text.isNotEmpty;
  }
}
