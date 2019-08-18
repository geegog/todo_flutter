import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final routes = <String, WidgetBuilder>{
    '/': (context) => LoginPage(),
    RegisterPage.tag: (context) => RegisterPage(),
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
        initialRoute: '/',
      routes: routes,
    );
  }
}
