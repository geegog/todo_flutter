import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget{
  @override
  LoginState createState() => new LoginState();
}

class LoginState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/logo.png'),
      ),
    );

    return new Scaffold();
  }

}