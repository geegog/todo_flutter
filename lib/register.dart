import 'package:flutter/material.dart';
import 'package:todo_backend_flutter/login.dart';
import 'package:http/http.dart';

class RegisterPage extends StatefulWidget {
  static String tag = 'register-page';

  @override
  RegisterState createState() => new RegisterState();
}

class RegisterState extends State<RegisterPage> {

  final _formKey = new GlobalKey<FormState>();

  Function decoration = (String text) => InputDecoration(
    hintText: text,
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
  );

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

    final form = Form(
      key: _formKey,
      child: Column(children: <Widget>[
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          autofocus: true,
          decoration: decoration('Enter email'),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter your email';
            }
            return null;
          },
        ),
        SizedBox(height: 8.0),
        TextFormField(
          keyboardType: TextInputType.text,
          autofocus: false,
          decoration: decoration('Enter name'),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        SizedBox(height: 8.0),
        TextFormField(
          keyboardType: TextInputType.phone,
          autofocus: false,
          decoration: decoration('Enter phone'),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter your phone';
            }
            return null;
          },
        ),
        SizedBox(height: 8.0),
        TextFormField(
          keyboardType: TextInputType.text,
          autofocus: false,
          obscureText: true,
          decoration: decoration('Enter password'),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter your password';
            }
            return null;
          },
        ),
        SizedBox(height: 8.0),
        TextFormField(
          keyboardType: TextInputType.text,
          autofocus: false,
          obscureText: true,
          decoration: decoration('Confirm password'),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please confirm your password';
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
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.

                }
              },
              padding: EdgeInsets.all(12),
              color: Colors.green,
              child: Text('Log In', style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ]),
    );

    final loginLabel = FlatButton(
      child: Text(
        'Already have an account',
        style: TextStyle(color: Colors.blue),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(LoginPage.tag);
      },
    );

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              logo,
              SizedBox(height: 48.0),
              form,
              new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [loginLabel])
            ],
          ),
        ),
      ),
    );
  }
}
