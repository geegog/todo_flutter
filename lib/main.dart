import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_flutter/authentication/bloc.dart';
import 'package:todo_flutter/common/bloc/simple_bloc_delegate.dart';
import 'package:todo_flutter/common/domain/repository/user_repository.dart';
import 'package:todo_flutter/common/pages/home.dart';
import 'package:todo_flutter/common/pages/login_page.dart';
import 'package:todo_flutter/task/bloc/alltodo/bloc.dart';
import 'common/services/service_locator.dart';

void main() async {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  await setupLocator();
  final userRepository = UserRepository();
  runApp(
    BlocProvider<AuthenticationBloc>(
      builder: (context) {
        return AuthenticationBloc(userRepository: userRepository)
          ..dispatch(AppStarted());
      },
      child: MyApp(userRepository: userRepository,),
    ),);
}

class MyApp extends StatelessWidget {

  final UserRepository userRepository;

  MyApp({Key key, @required this.userRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return BlocProvider(
              builder: (context) => TodoBloc()..dispatch(Fetch()),
              child: TodoHomePage(),
            );
          }
          if (state is Unauthenticated) {
            return LoginPage(userRepository: userRepository);
          }
          return Text('Loading');
        },
      ),
    );
  }
}
