import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_flutter/login.dart';
import 'pojo/user.dart';
import 'pojo/user_request.dart';
import 'api.dart';

class RegisterPage extends StatefulWidget {
  static String tag = 'register-page';

  @override
  RegisterState createState() => new RegisterState();
}

class RegisterState extends State<RegisterPage> {
  final _formKey = new GlobalKey<FormState>();

  Function decoration = (String text, Icon icon) => InputDecoration(
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
          controller: myControllerEmail,
          keyboardType: TextInputType.emailAddress,
          autofocus: true,
          decoration: decoration('Enter email', new Icon(Icons.email, color: Colors.green)),
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
          decoration: decoration('Enter name', new Icon(Icons.person, color: Colors.green)),
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
          decoration: decoration('Enter phone', new Icon(Icons.phone, color: Colors.green)),
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
          decoration: decoration('Enter password', new Icon(Icons.lock, color: Colors.green)),
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
          decoration: decoration('Confirm password', new Icon(Icons.lock, color: Colors.green)),
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
                onPressed: () {
                  // Validate returns true if the form is valid, or false
                  // otherwise.
                  if (_formKey.currentState.validate()) {
                    User user = User(
                        myControllerName.text,
                        myControllerEmail.text,
                        myControllerPhone.text,
                        myControllerPassword.text,
                        myControllerConfirmPassword.text);

                    String userRequest = jsonEncode(UserRequest(user));

                    Future<dynamic> response = APIUtil().post(
                        'http://172.31.128.20:4000/api/v1/sign_up',
                        userRequest);

                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Container(
                          child: FutureBuilder<dynamic>(
                            future: response,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(snapshot.data);
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              }

                              // By default, show a loading spinner.
                              return new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [CircularProgressIndicator()]);
                            },
                          ),
                        ),
                      ),
                    );
                  }
                },
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
                  children: [loginLabel]),
            ],
          ),
        ),
      ),
    );
  }
}
