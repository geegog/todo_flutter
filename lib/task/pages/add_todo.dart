
import 'package:flutter/material.dart';

class AddTodoPage extends StatefulWidget {
  static const String tag = '/';

  @override
  AddTodoState createState() => new AddTodoState();
}

class AddTodoState extends State<AddTodoPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new Todo'),
        actions: <Widget>[
        ],
      ),
    );
  }
  
}