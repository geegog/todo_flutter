
String formatTimeNumber(int number) {
  return (number >= 0 && number <= 9) ? '0' + number.toString() : number.toString();
}