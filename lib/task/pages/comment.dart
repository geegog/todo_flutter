import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_flutter/common/utils/date_time.dart' as dateTimeUtil;
import 'package:todo_flutter/task/domain/model/todo_category.dart';

class CommentPage extends StatefulWidget {
  static const String tag = '/todo-comments';

  CommentPage(
      {Key key,})
      : super(key: key);

  @override
  CommentPageState createState() => new CommentPageState();
}

class CommentPageState extends State<CommentPage> {

  Completer<void> _refreshCompleter;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (maxScroll - currentScroll <= _scrollThreshold) {

      }
    });
    _refreshCompleter = Completer<void>();
  }


  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildList() {
    return Column(
      children: <Widget>[
        ListTile(
          title: Row(
            children: <Widget>[
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
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: BlocListener(
        listener: (context, state) {
          if (state) {
            _refreshCompleter?.complete();
            _refreshCompleter = Completer();
          }
        },
        child: BlocBuilder(
          builder: (context, state) {
            if (state) {
              return Center(
                child: Text('failed to fetch comments'),
              );
            }
            if (state) {
              if (state.todos.isEmpty) {
                return Center(
                  child: Text('no comments'),
                );
              }
              return RefreshIndicator(
                key: _refreshIndicatorKey,
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return index >= state.todos.length
                        ? BottomLoader()
                        : _buildList();
                  },
                  itemCount: state.hasReachedMax
                      ? state.todos.length
                      : state.todos.length + 1,
                  controller: _scrollController,
                ),
                onRefresh: () {
                  //widget.todoBloc.dispatch(RefreshTodo());
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
