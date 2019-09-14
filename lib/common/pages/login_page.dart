import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_flutter/authentication/bloc.dart';
import 'package:todo_flutter/common/bloc/login/bloc.dart';
import 'package:todo_flutter/common/pages/register.dart';

class LoginPage extends StatefulWidget {
  static const String tag = '/';

  @override
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final Function decoration = (String text, Icon icon) => InputDecoration(
        prefixIcon: icon,
        hintText: text,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      );

  final TextEditingController _myControllerEmail = TextEditingController();
  final TextEditingController _myControllerPassword = TextEditingController();
  LoginBloc _loginBloc;

  bool get isPopulated =>
      _myControllerEmail.text.isNotEmpty &&
      _myControllerPassword.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _myControllerEmail.addListener(_onEmailChanged);
    _myControllerPassword.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _myControllerEmail.dispose();
    _myControllerPassword.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _loginBloc.dispatch(
      EmailChanged(email: _myControllerEmail.text),
    );
  }

  void _onPasswordChanged() {
    _loginBloc.dispatch(
      PasswordChanged(password: _myControllerPassword.text),
    );
  }

  void _onFormSubmitted() {
    _loginBloc.dispatch(
      LoginWithCredentialsPressed(
        email: _myControllerEmail.text,
        password: _myControllerPassword.text,
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

  Widget registerLabel() {
    return FlatButton(
      child: Text(
        'Create a new account',
        style: TextStyle(color: Colors.green),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegisterPage()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.isFailure) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Login Failure'), Icon(Icons.error)],
                  ),
                  backgroundColor: Colors.red,
                ),
              );
          }
          if (state.isSubmitting) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Logging In...'),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
          }
          if (state.isSuccess) {
            BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedIn());
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(left: 24.0, right: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 48.0),
                      logo(),
                      SizedBox(height: 48.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _myControllerEmail,
                              keyboardType: TextInputType.emailAddress,
                              autovalidate: true,
                              autocorrect: false,
                              autofocus: false,
                              decoration: decoration("Enter email",
                                  new Icon(Icons.email, color: Colors.white)),
                              validator: (_) {
                                return !state.isEmailValid
                                    ? 'Invalid Email'
                                    : null;
                              },
                            ),
                            SizedBox(height: 8.0),
                            TextFormField(
                              controller: _myControllerPassword,
                              keyboardType: TextInputType.text,
                              autovalidate: true,
                              autocorrect: false,
                              autofocus: false,
                              obscureText: true,
                              decoration: decoration('Enter password',
                                  new Icon(Icons.lock, color: Colors.white)),
                              validator: (_) {
                                return !state.isPasswordValid
                                    ? 'Invalid Password'
                                    : null;
                              },
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: ButtonTheme(
                                minWidth: double.infinity,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  onPressed: isLoginButtonEnabled(state)
                                      ? _onFormSubmitted
                                      : null,
                                  padding: EdgeInsets.all(12),
                                  color: Colors.green,
                                  child: Text('Log In',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [registerLabel()]),
                      SizedBox(height: 48.0),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
