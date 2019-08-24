import 'package:flutter/material.dart';
import 'package:todo_flutter/common/pages/home.dart';
import 'package:todo_flutter/common/pages/register.dart';
import 'package:todo_flutter/common/services/auth.dart';
import 'common/pages/login.dart';
import 'common/services/service_locator.dart';

void main() async {
  await setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: (services.get<Auth>().getToken() != null ||
              !services.get<Auth>().isTokenExpired())
          ? HomePage()
          : LoginPage(),
    );
  }
}
