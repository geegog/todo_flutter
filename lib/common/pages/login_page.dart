import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_flutter/authentication/bloc.dart';
import 'package:todo_flutter/common/bloc/login/bloc.dart';
import 'package:todo_flutter/common/domain/repository/user_repository.dart';
import 'package:todo_flutter/common/pages/login_form.dart';

class LoginPage extends StatelessWidget {
  final UserRepository _userRepository;

  LoginPage({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: BlocProvider<LoginBloc>(
        builder: (context) => LoginBloc(userRepository: _userRepository),
        child: LoginForm(userRepository: _userRepository),
      ),
    );
  }
}
