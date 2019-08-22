import 'package:flutter/material.dart';
import 'common/pages/login.dart';
import 'common/pages/register.dart';
import 'common/pages/home.dart';
import 'common/services/storage.dart';
import 'common/services/service_locator.dart';

void main() async {
  await setupLocator();
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
      initialRoute: (services.get<Storage>().getToken() != null) ? HomePage.tag : '/',
      routes: routes,
    );
  }
}
