import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_flutter/task/bloc/alltodo/bloc.dart';
import 'package:todo_flutter/task/domain/model/todo.dart';

class AllTodoPage extends StatefulWidget {
  static const String tag = '/all-todos';

  AllTodoPage({Key key, this.pageController}) : super(key: key);

  final PageController pageController;

  @override
  AllTodoState createState() => new AllTodoState();
}

class AllTodoState extends State<AllTodoPage> {
  Completer<void> _refreshCompleter;
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  TodoBloc _todoBloc;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (maxScroll - currentScroll <= _scrollThreshold) {
        _todoBloc.dispatch(Fetch());
      }
    });
    _todoBloc = BlocProvider.of<TodoBloc>(context);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildList(Todo todo) {
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
                          todo.title,
                          style: TextStyle(color: Colors.black, fontSize: 20.0),
                        ),
                      ),
                    ],
                  ),
                ),
                LimitedBox(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      todo.deadline,
                      style: TextStyle(color: Colors.grey, fontSize: 10.0),
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
                    todo.description,
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
            print(todo.description);
          },
        ),
        Divider(
          color: Colors.grey,
        ),
      ],
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
      body: BlocListener<TodoBloc, TodoState>(
        listener: (context, state) {
          print('***********');
          print(state.toString());
          print('***********');
          if (state is TodoLoaded) {
            _refreshCompleter?.complete();
            _refreshCompleter = Completer();
          }
        },
        child: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            if (state is TodoError) {
              return Center(
                child: Text('failed to fetch todos'),
              );
            }
            if (state is TodoLoaded) {
              print(state.todos.length);
              if (state.todos.isEmpty) {
                return Center(
                  child: Text('no todos'),
                );
              }
              return RefreshIndicator(
                key: _refreshIndicatorKey,
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return index >= state.todos.length
                        ? BottomLoader()
                        : _buildList(state.todos[index]);
                  },
                  itemCount: state.hasReachedMax
                      ? state.todos.length
                      : state.todos.length + 1,
                  controller: _scrollController,
                ),
                onRefresh: () {
                  _todoBloc.dispatch(Refresh());
                  return _refreshCompleter.future;
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}
