import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_flutter/common/utils/api.dart';
import 'package:todo_flutter/user/dto/user.dart';
import 'package:todo_flutter/user/dto/user_request.dart';
import 'package:todo_flutter/common/components/snackbar.dart';

class RegisterPage extends StatefulWidget {
  static const String tag = '/register-page';

  @override
  RegisterState createState() => new RegisterState();
}

class RegisterState extends State<RegisterPage> {
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
  final myControllerName = TextEditingController();
  final myControllerPhone = TextEditingController();
  final myControllerConfirmPassword = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myControllerEmail.dispose();
    myControllerPassword.dispose();
    myControllerName.dispose();
    myControllerConfirmPassword.dispose();
    myControllerPhone.dispose();
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

  _registerUser() async {
    _showLoading();

    if (_formKey.currentState.validate()) {
      User user = User(
          myControllerName.text,
          myControllerEmail.text,
          myControllerPhone.text,
          myControllerPassword.text,
          myControllerConfirmPassword.text);

      String userRequest = jsonEncode(UserRequest(user));

      var response = await APIUtil().post('sign_up', userRequest);

      Map<String, dynamic> responseObj = json.decode(response);

      if (responseObj['errors'] != null) {
        Snack.snack(responseObj['errors'].toString(), _scaffoldKey);
      } else if (responseObj['error'] != null) {
        Snack.snack(responseObj['error'], _scaffoldKey);
      } else {
        setState(() {
          myControllerName.clear();
          myControllerEmail.clear();
          myControllerPhone.clear();
          myControllerPassword.clear();
          myControllerConfirmPassword.clear();
        });
        Snack.snack("Accout created successfully. Please login...", _scaffoldKey);
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
              'Enter email', new Icon(Icons.email, color: Colors.green)),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter your email';
            }
            return null;
          },
        ),
        SizedBox(height: 8.0),
        TextFormField(
          controller: myControllerName,
          keyboardType: TextInputType.text,
          autofocus: false,
          decoration: decoration(
              'Enter name', new Icon(Icons.person, color: Colors.green)),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        SizedBox(height: 8.0),
        TextFormField(
          controller: myControllerPhone,
          keyboardType: TextInputType.phone,
          autofocus: false,
          decoration: decoration(
              'Enter phone', new Icon(Icons.phone, color: Colors.green)),
          validator: (value) {
            if (value.isEmpty && value.length < 11) {
              return 'Please enter a valid phone';
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
            if (value.isEmpty || value.length < 8) {
              return 'Password must be at least 8 characters';
            }
            return null;
          },
        ),
        SizedBox(height: 8.0),
        TextFormField(
          controller: myControllerConfirmPassword,
          keyboardType: TextInputType.text,
          autofocus: false,
          obscureText: true,
          decoration: decoration(
              'Confirm password', new Icon(Icons.lock, color: Colors.green)),
          validator: (value) {
            if (value.isEmpty || value != myControllerPassword.text) {
              return 'Confirmation password does not match';
            }
            return null;
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ButtonTheme(
            minWidth: double.infinity,
            child: Builder(
              builder: (context) => RaisedButton(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                onPressed: _registerUser,
                padding: EdgeInsets.all(12),
                color: Colors.green,
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget loginLabel() {
    return FlatButton(
      child: Text(
        'Already have an account',
        style: TextStyle(color: Colors.blue),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Widget _registerScreen() {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 48.0),
            logo(),
            SizedBox(height: 48.0),
            form(),
            new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [loginLabel()]),
            SizedBox(height: 48.0),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      key: _scaffoldKey,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _registerScreen(),
    );
  }
}
