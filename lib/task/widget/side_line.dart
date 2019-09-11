import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Color color(String dateTime) {
  DateTime parsedDate = DateTime.parse(dateTime);

  Duration duration = DateTime.now().difference(parsedDate);

  if (duration.isNegative) {
    return Colors.red;
  }

  if (duration.inDays == 0) {
    return Colors.orangeAccent;
  }

  return Colors.blue;
}
