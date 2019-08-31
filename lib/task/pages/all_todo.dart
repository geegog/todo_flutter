import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_flutter/common/utils/api.dart';

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
  String nextPage = "todo/all";
  ScrollController _scrollController = new ScrollController();
  bool isLoading = false;
  List todos = new List();

  @override
  void initState() {
    // TODO: implement initState
    this._getTodos();
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getTodos();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _getTodos() async {
    if (!isLoading && nextPage != null) {
      setState(() {
        isLoading = true;
      });

      final response = await APIUtil().fetch(nextPage);
      Map<String, dynamic> responseObj = json.decode(response);
      List tempList = new List();
      print(responseObj['metadata']);
      if (responseObj['metadata']['after'] != null) {
        String after = responseObj['metadata']['after'];
        nextPage = "todo/all?after=$after";
      } else {
        nextPage = null;
      }

      for (int i = 0; i < responseObj['data'].length; i++) {
        tempList.add(responseObj['data'][i]);
      }

      setState(() {
        isLoading = false;
        todos.addAll(tempList);
      });
    }
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      //+1 for progressbar
      itemCount: nextPage != null ? todos.length + 1 : todos.length,
      itemBuilder: (BuildContext context, int index) {
        if (index == todos.length) {
          return _buildProgressIndicator();
        } else {
          return new ListTile(
            title: ListBody(
              children: <Widget>[
                Row(children: <Widget>[Icon(Icons.person), Text(todos[index]['user']['name'])]),
                Row(children: <Widget>[Icon(Icons.title), Text(todos[index]['title'])]),
                Row(children: <Widget>[Icon(Icons.description), Text(todos[index]['description'])]),
              ],
            ),
            onTap: () {
              print(todos[index]);
            },
          );
        }
      },
      controller: _scrollController,
    );
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
      body: _buildList(),
    );
  }
}
