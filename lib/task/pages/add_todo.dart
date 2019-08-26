import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_flutter/common/components/date_time_picker.dart';
import 'package:todo_flutter/common/pages/home.dart';
import 'package:todo_flutter/common/services/auth.dart';
import 'package:todo_flutter/common/services/service_locator.dart';
import 'package:todo_flutter/task/dto/todo.dart';
import 'package:todo_flutter/task/dto/todo_request.dart';

class AddTodoPage extends StatefulWidget {
  static const String tag = '/add-todo';

  AddTodoPage({Key key}) : super(key: key);

  @override
  AddTodoState createState() => new AddTodoState();
}

class AddTodoState extends State<AddTodoPage> {
  final _formKey = new GlobalKey<FormState>();
  final selectedDate = DateTime.now();

  final myControllerTitle = TextEditingController();
  final myControllerDesc = TextEditingController();

  DateTime _endDate = DateTime.now();
  TimeOfDay _endTime = const TimeOfDay(hour: 7, minute: 28);

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myControllerTitle.dispose();
    myControllerDesc.dispose();
    super.dispose();
  }

  final Function decoration = (String text, Icon icon) => InputDecoration(
        prefixIcon: icon,
        hintText: text,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      );

  Widget form() {
    return Form(
      key: _formKey,
      child: Column(children: <Widget>[
        TextFormField(
          maxLength: 25,
          controller: myControllerTitle,
          keyboardType: TextInputType.text,
          autofocus: false,
          decoration: decoration(
              'Enter title', new Icon(Icons.title, color: Colors.green)),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter your title';
            }
            return null;
          },
        ),
        SizedBox(height: 8.0),
        TextFormField(
          maxLength: 150,
          minLines: 5,
          maxLines: 6,
          controller: myControllerDesc,
          keyboardType: TextInputType.multiline,
          autofocus: false,
          decoration: decoration('Enter description',
              new Icon(Icons.description, color: Colors.green)),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter description';
            }
            return null;
          },
        ),
        SizedBox(height: 8.0),
        new DateTimePicker(
          labelText: 'Choose Dead Line',
          selectedDate: _endDate,
          selectedTime: _endTime,
          selectDate: (DateTime date) {
            setState(() {
              _endDate = date;
            });
          },
          selectTime: (TimeOfDay time) {
            setState(() {
              _endTime = time;
            });
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
                onPressed: _addTodo,
                padding: EdgeInsets.all(12),
                color: Colors.green,
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _addTodoScreen() {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 48.0),
            form(),
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
      appBar: AppBar(
        title: Text('Add new Todo'),
        actions: <Widget>[],
      ),
      body: _addTodoScreen(),
    );
  }

  void _addTodo() async {
    if (_formKey.currentState.validate()) {
      print(_endDate.toIso8601String());
      print(_endTime.toString());

      String datetime = _endDate.toIso8601String().split('T')[0] +
          ' ' +
          _endTime.hour.toString() +
          ':' +
          _endTime.minute.toString() +
          ':00';
      print(datetime);
      print('todo/user/' + services.get<Auth>().getUserId() + '/create');

      Todo todo = Todo(datetime, myControllerDesc.text, myControllerTitle.text);

      String todoRequest = jsonEncode(TodoRequest(todo));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TodoHomePage(state: todoRequest, isTodoHome: false,)),
      );

      /*var response = await APIUtil().post(
          'todo/user/' + services.get<Auth>().getUserId() + '/create',
          todoRequest);

      Map<String, dynamic> responseObj = json.decode(response);*/
    }
  }
}
