import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_flutter/common/pages/home.dart';
import 'package:todo_flutter/common/services/auth.dart';
import 'package:todo_flutter/task/bloc/bloc.dart';
import 'common/pages/login.dart';
import 'common/services/service_locator.dart';

void main() async {
  BlocSupervisor.delegate = SimpleBlocDelegate();
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
        primarySwatch: Colors.green,
      ),
      home: (services.get<Auth>().getToken() != null ||
              !services.get<Auth>().isTokenExpired())
          ? BlocProvider(
              builder: (context) => TodoBloc()..dispatch(Fetch()),
              child: TodoHomePage(),
            )
          : LoginPage(),
    );
  }
}
