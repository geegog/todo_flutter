import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_flutter/register.dart';

import 'api.dart';
import 'auth.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  static String tag = '/login-page';

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

      var response = await APIUtil.post(
          'http://172.31.128.20:4000/api/v1/sign_in', loginRequest);

      print(response);

      Map<String, dynamic> responseObj = json.decode(response);

      if (responseObj['errors'] != null) {
        _snack(responseObj['errors'].toString());
        _hideLoading();
      } else if (responseObj['error'] != null) {
        _snack(responseObj['error']);
        _hideLoading();
      } else {
        Auth.setToken(responseObj['jwt']);
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => HomePage()),
        );
        _hideLoading();
      }
    } else {
      _hideLoading();
    }
  }

  _snack(String message) {
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: new Text(message),
      ),
    );
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
          CupertinoPageRoute(builder: (context) => RegisterPage()),
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
            logo(),
            SizedBox(height: 48.0),
            form(),
            new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [registerLabel()])
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
