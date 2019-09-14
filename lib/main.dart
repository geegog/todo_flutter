import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_flutter/authentication/bloc.dart';
import 'package:todo_flutter/common/bloc/simple_bloc_delegate.dart';
import 'package:todo_flutter/common/pages/home.dart';
import 'package:todo_flutter/common/pages/login_page.dart';
import 'package:todo_flutter/task/bloc/alltodo/bloc.dart';
import 'common/bloc/login/bloc.dart';
import 'common/services/service_locator.dart';

void main() async {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  await setupLocator();
  runApp(
    BlocProvider<AuthenticationBloc>(
      builder: (context) {
        return AuthenticationBloc()..dispatch(AppStarted());
      },
      child: MyApp(),
    ),
  );
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
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        condition: (previousState, currentState) {
          return true;
        },
        builder: (context, state) {
          if (state is Authenticated) {
            return BlocProvider(
              builder: (context) => TodoBloc()..dispatch(Fetch()),
              child: TodoHomePage(),
            );
          } else {
            return BlocProvider<LoginBloc>(
              builder: (context) => LoginBloc(),
              child: LoginPage(),
            );
          }
        },
      ),
    );
  }
}
