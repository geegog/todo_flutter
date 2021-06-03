import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_flutter/common/widgets/bottom_loader.dart';
import 'package:todo_flutter/task/bloc/alltodo/bloc.dart';
import 'package:todo_flutter/common/utils/date_time.dart' as dateTimeUtil;
import 'package:todo_flutter/task/bloc/comment/bloc.dart';
import 'package:todo_flutter/task/domain/model/todo_category.dart';
import 'package:todo_flutter/task/pages/comment.dart';
import 'package:todo_flutter/task/widget/side_line.dart' as line;

class AllTodoPage extends StatefulWidget {
  static const String tag = '/all-todos';

  AllTodoPage(
      {Key key,
      this.pageController,
      @required this.todoBloc,
      @required this.scrollController})
      : super(key: key);

  final PageController pageController;
  final ScrollController scrollController;
  final todoBloc;

  @override
  AllTodoState createState() => new AllTodoState();
}

class AllTodoState extends State<AllTodoPage> {
  Completer<void> _refreshCompleter;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildList(TodoCategory todoCategory) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Row(
            children: <Widget>[
              Container(
                color: line.color(todoCategory.todo.deadline),
                height: 60.0,
                child: VerticalDivider(
                  width: 2.0,
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        LimitedBox(
                          maxWidth: 200.0,
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.title,
                                  size: 15.0,
                                  color:
                                      line.color(todoCategory.todo.deadline)),
                              SizedBox(
                                width: 8.0,
                              ),
                              Expanded(
                                child: Text(
                                  todoCategory.todo.title,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              dateTimeUtil
                                  .formatDateTime(todoCategory.todo.deadline),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 10.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Row(children: <Widget>[
                      SizedBox(
                        width: 40.0,
                      ),
                      Expanded(
                        child: Text(
                          todoCategory.todo.description,
                          style: TextStyle(color: Colors.grey, fontSize: 15.0),
                        ),
                      ),
                    ]),
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.chat_bubble,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) =>
                                      CommentBloc(CommentUninitialized())..add(FetchComment(todoId: todoCategory.todo.id)),
                                  child: CommentPage(todoCategory: todoCategory,),
                                ),
                              ),
                            );
                          },
                        ),
                        Text(
                          '${todoCategory.commentsCount}',
                          style: TextStyle(color: Colors.grey, fontSize: 18.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
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
                  controller: widget.scrollController,
                ),
                onRefresh: () {
                  widget.todoBloc.add(RefreshTodo());
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
