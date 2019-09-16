import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_flutter/common/bloc/register/bloc.dart';

class RegisterPage extends StatefulWidget {
  static const String tag = '/register-page';

  @override
  RegisterPageState createState() => new RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final Function decoration = (String text, Icon icon) => InputDecoration(
        prefixIcon: icon,
        hintText: text,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      );

  final _myControllerEmail = TextEditingController();
  final _myControllerPassword = TextEditingController();
  final _myControllerName = TextEditingController();
  final _myControllerPhone = TextEditingController();
  final _myControllerConfirmPassword = TextEditingController();
  RegisterBloc _registerBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _myControllerEmail.addListener(_onEmailChanged);
    _myControllerPassword.addListener(_onPasswordChanged);
    _myControllerConfirmPassword.addListener(_onConfirmPasswordChanged);
    _myControllerPhone.addListener(_onPhoneChanged);
    _myControllerName.addListener(_onNameChanged);
  }

  bool get isPopulated =>
      _myControllerEmail.text.isNotEmpty &&
      _myControllerPassword.text.isNotEmpty &&
      _myControllerConfirmPassword.text.isNotEmpty &&
      _myControllerName.text.isNotEmpty &&
      _myControllerPhone.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _myControllerEmail.dispose();
    _myControllerPassword.dispose();
    _myControllerName.dispose();
    _myControllerConfirmPassword.dispose();
    _myControllerPhone.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _registerBloc.dispatch(
      EmailChanged(email: _myControllerEmail.text),
    );
  }

  void _onPasswordChanged() {
    _registerBloc.dispatch(
      PasswordChanged(
          password: _myControllerPassword.text,
          confirmPassword: _myControllerConfirmPassword.text),
    );
  }

  void _onConfirmPasswordChanged() {
    _registerBloc.dispatch(
      ConfirmPasswordChanged(
          password: _myControllerPassword.text,
          confirmPassword: _myControllerConfirmPassword.text),
    );
  }

  void _onPhoneChanged() {
    _registerBloc.dispatch(
      PhoneChanged(phone: _myControllerPhone.text),
    );
  }

  void _onNameChanged() {
    _registerBloc.dispatch(
      NameChanged(name: _myControllerName.text),
    );
  }

  void _onFormSubmitted() {
    _registerBloc.dispatch(
      RegisterButtonPressed(
          email: _myControllerEmail.text,
          password: _myControllerPassword.text,
          phone: _myControllerPhone.text,
          name: _myControllerName.text,
          confirmPassword: _myControllerConfirmPassword.text),
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

  Widget loginLabel() {
    return FlatButton(
      child: Text(
        'Already have an account',
        style: TextStyle(color: Colors.green),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      key: _scaffoldKey,
      body: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) async {
          if (state.isFailure) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(state.message),
                      ),
                      Icon(Icons.error)
                    ],
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
                  duration: Duration(minutes: 5),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Registering User...'),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
          }
          if (state.isSuccess) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 6),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Request successful ...'),
                      RaisedButton(
                          child: Text('Click to Login'),
                          color: Colors.green,
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ],
                  ),
                ),
              );

            await Future.delayed(Duration(seconds: 6));
            Navigator.of(context).pop();

          }
        },
        child: BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, state) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(left: 24.0, right: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 48.0),
                      logo(),
                      SizedBox(height: 48.0),
                      Form(
                        key: _formKey,
                        child: Column(children: <Widget>[
                          TextFormField(
                            controller: _myControllerEmail,
                            keyboardType: TextInputType.emailAddress,
                            autovalidate: true,
                            autocorrect: false,
                            autofocus: false,
                            decoration: decoration('Enter email',
                                new Icon(Icons.email, color: Colors.white)),
                            validator: (_) {
                              return !state.isEmailValid
                                  ? 'Invalid Email'
                                  : null;
                            },
                          ),
                          SizedBox(height: 8.0),
                          TextFormField(
                            controller: _myControllerName,
                            keyboardType: TextInputType.text,
                            autovalidate: true,
                            autocorrect: false,
                            autofocus: false,
                            decoration: decoration('Enter name',
                                new Icon(Icons.person, color: Colors.white)),
                            validator: (_) {
                              return !state.isNameValid ? 'Invalid Name' : null;
                            },
                          ),
                          SizedBox(height: 8.0),
                          TextFormField(
                            controller: _myControllerPhone,
                            keyboardType: TextInputType.phone,
                            autovalidate: true,
                            autocorrect: false,
                            autofocus: false,
                            decoration: decoration('Enter phone',
                                new Icon(Icons.phone, color: Colors.white)),
                            validator: (_) {
                              return !state.isPhoneValid
                                  ? 'Invalid Phone'
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
                                  ? 'Password must be at least 8 characters'
                                  : null;
                            },
                          ),
                          SizedBox(height: 8.0),
                          TextFormField(
                            controller: _myControllerConfirmPassword,
                            keyboardType: TextInputType.text,
                            autovalidate: true,
                            autocorrect: false,
                            autofocus: false,
                            obscureText: true,
                            decoration: decoration('Confirm password',
                                new Icon(Icons.lock, color: Colors.white)),
                            validator: (_) {
                              return !state.isConfirmPasswordValid
                                  ? 'Passwords don\'t match'
                                  : null;
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ButtonTheme(
                              minWidth: double.infinity,
                              child: Builder(
                                builder: (context) => RaisedButton(
                                  elevation: 10.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  onPressed: isRegisterButtonEnabled(state)
                                      ? _onFormSubmitted
                                      : null,
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
                      ),
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [loginLabel()]),
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
