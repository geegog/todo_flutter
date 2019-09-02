import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_flutter/common/utils/api.dart';

class AllTodoPage extends StatefulWidget {
  static const String tag = '/all-todos';

  AllTodoPage(
      {Key key,
      this.addTodoToList,
      this.isNewRequest = false,
      this.pageController})
      : super(key: key);

  final addTodoToList;
  final bool isNewRequest;
  final PageController pageController;

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
          return Column(
            children: <Widget>[
              ListTile(
                title: ListBody(
                  children: <Widget>[
                    Row(children: <Widget>[
                      LimitedBox(
                        maxWidth: 200.0,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.title),
                            SizedBox(
                              width: 8.0,
                            ),
                            Expanded(
                              child: Text(
                                todos[index]['title'],
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      LimitedBox(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                            todos[index]['deadline'],
                            style:
                                TextStyle(color: Colors.grey, fontSize: 10.0),
                          ),
                        ),
                      ),
                    ]),
                    SizedBox(
                      height: 8.0,
                    ),
                    Row(children: <Widget>[
                      SizedBox(
                        width: 40.0,
                      ),
                      Expanded(
                        child: Text(
                          todos[index]['description'],
                          style: TextStyle(color: Colors.grey, fontSize: 15.0),
                        ),
                      ),
                    ]),
                    Row(children: <Widget>[
                      SizedBox(
                        width: 40.0,
                      ),
                      Icon(
                        Icons.comment,
                        size: 15.0,
                      ),
                      Text(
                        '0',
                        style: TextStyle(color: Colors.grey, fontSize: 15.0),
                      ),
                    ]),
                  ],
                ),
                onTap: () {
                  print(todos[index]);
                },
              ),
              Divider(color: Colors.grey,),
            ],
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
      floatingActionButton: Opacity(
        opacity: 0.8,
        child: FloatingActionButton(
          child: Center(
            child: Icon(Icons.add),
          ),
          onPressed: () {
            widget.pageController.nextPage(
                duration: Duration(milliseconds: 200), curve: Curves.linear);
          },
        ),
      ),
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
