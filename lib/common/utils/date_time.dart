
String formatTimeNumber(int number) {
  return (number >= 0 && number <= 9) ? '0' + number.toString() : number.toString();
}

String formatDateTime(String dateTime) {
  DateTime parsedDate = DateTime.parse(dateTime);

  Duration duration = parsedDate.difference(DateTime.now());

  if(duration.isNegative) {
    return dateTime.replaceAll('T', ' ');
  }

  if(duration.inDays == 0) {
    return 'Today';
  }

  return 'In ' + duration.inDays.toString() + ' day(s)';
}