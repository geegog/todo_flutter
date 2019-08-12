import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  final routes = <String, WidgetBuilder>{
    RegisterPage.tag: (context) => RegisterPage(),
    LoginPage.tag: (context) => LoginPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
        home: LoginPage(),
      routes: routes,
    );
  }
}
