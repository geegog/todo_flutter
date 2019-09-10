import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Snack {
  static snack(String message, GlobalKey<ScaffoldState> globalKey) {
    globalKey.currentState.showSnackBar(
      new SnackBar(
        content: new Text(message),
      ),
    );
  }
}
