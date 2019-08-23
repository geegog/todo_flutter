
import 'package:flutter/cupertino.dart';
import 'package:todo_flutter/common/pages/home.dart';
import 'package:todo_flutter/common/pages/login.dart';
import 'package:todo_flutter/common/pages/register.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginPage.tag:
      return CupertinoPageRoute(builder: (context) => LoginPage());
    case RegisterPage.tag:
      return CupertinoPageRoute(builder: (context) => RegisterPage());
    default:
      return CupertinoPageRoute(builder: (context) => LoginPage());
  }
}

Route<dynamic> privateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomePage.tag:
      return CupertinoPageRoute(builder: (context) => HomePage());
    default:
      return CupertinoPageRoute(builder: (context) => HomePage());
  }
}