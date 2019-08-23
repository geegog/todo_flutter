import 'package:flutter/material.dart';
import 'common/pages/login.dart';
import 'common/services/service_locator.dart';
import 'package:todo_flutter/common/components/router.dart' as router;

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
      initialRoute: LoginPage.tag,
      onGenerateRoute: router.generateRoute,
    );
  }
}
