import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_flutter/common/components/snackbar.dart';
import 'package:todo_flutter/common/pages/register.dart';
import 'package:todo_flutter/common/services/auth.dart';
import 'package:todo_flutter/common/services/service_locator.dart';
import 'package:todo_flutter/common/utils/api.dart';

import 'home.dart';

class LoginPage extends StatefulWidget {
  static const String tag = '/';

  @override
  LoginState createState() => new LoginState();
}

class LoginState extends State<LoginPage> {
  bool _isLoading = false;
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final Function decoration = (String text, Icon icon) => InputDecoration(
        prefixIcon: icon,
        hintText: text,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      );

  final myControllerEmail = TextEditingController();
  final myControllerPassword = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myControllerEmail.dispose();
    myControllerPassword.dispose();
    super.dispose();
  }

  _showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  _hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  _authenticateUser() async {
    _showLoading();

    if (_formKey.currentState.validate()) {
      String loginRequest = jsonEncode({
        'email': myControllerEmail.text,
        'password': myControllerPassword.text
      });

      var response = await APIUtil().post('sign_in', loginRequest);

      Map<String, dynamic> responseObj = json.decode(response);

      if (responseObj['errors'] != null) {
        Snack.snack(responseObj['errors'].toString(), _scaffoldKey);
      } else if (responseObj['error'] != null) {
        Snack.snack(responseObj['error'], _scaffoldKey);
      } else {
        services.get<Auth>().setToken(responseObj['jwt']);
        await services.get<Auth>().saveUser();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TodoHomePage()),
        );
      }
      _hideLoading();
    } else {
      _hideLoading();
    }
  }

  Widget logo() {
    return Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/logo.png'),
      ),
    );
  }

  Widget form() {
    return Form(
      key: _formKey,
      child: Column(children: <Widget>[
        TextFormField(
          controller: myControllerEmail,
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: decoration(
              "Enter email", new Icon(Icons.email, color: Colors.green)),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter your email';
            }
            return null;
          },
        ),
        SizedBox(height: 8.0),
        TextFormField(
          controller: myControllerPassword,
          keyboardType: TextInputType.text,
          autofocus: false,
          obscureText: true,
          decoration: decoration(
              'Enter password', new Icon(Icons.lock, color: Colors.green)),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter your password';
            }
            return null;
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ButtonTheme(
            minWidth: double.infinity,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              onPressed: _authenticateUser,
              padding: EdgeInsets.all(12),
              color: Colors.green,
              child: Text('Log In', style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ]),
    );
  }

  Widget registerLabel() {
    return FlatButton(
      child: Text(
        'Create a new account',
        style: TextStyle(color: Colors.blue),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegisterPage()),
        );
      },
    );
  }

  Widget _loginScreen() {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 48.0),
            logo(),
            SizedBox(height: 48.0),
            form(),
            new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [registerLabel()]),
            SizedBox(height: 48.0),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _loginScreen(),
    );
  }
}
