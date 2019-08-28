import 'package:flutter/material.dart';

class AllTodoPage extends StatefulWidget {
  static const String tag = '/all-todos';

  AllTodoPage({Key key, this.addTodoToList, this.isNewRequest = false})
      : super(key: key);

  final addTodoToList;
  final bool isNewRequest;

  @override
  AllTodoState createState() => new AllTodoState();
}

class AllTodoState extends State<AllTodoPage> {
  List todos;

  @override
  void didUpdateWidget(AllTodoPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Todos'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
              semanticLabel: 'add todo',
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            return ListTile();
          }),
    );
  }
}
