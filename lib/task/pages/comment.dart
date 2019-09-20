import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_flutter/task/bloc/comment/bloc.dart';
import 'package:todo_flutter/task/domain/model/comment.dart';

class CommentPage extends StatefulWidget {
  static const String tag = '/todo-comments';

  CommentPage({
    Key key,
  }) : super(key: key);

  @override
  CommentPageState createState() => new CommentPageState();
}

class CommentPageState extends State<CommentPage> {
  Completer<void> _refreshCompleter;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  final TextEditingController _myControllerText = TextEditingController();
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  CommentBloc _commentBloc;

  final Function decoration = (String text, Icon icon) => InputDecoration(
    prefixIcon: icon,
    hintText: text,
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(0.0)),
  );

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (maxScroll - currentScroll <= _scrollThreshold) {}
    });
    _refreshCompleter = Completer<void>();
    _commentBloc = BlocProvider.of<CommentBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildList(Comment comment) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Row(
            children: <Widget>[],
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
      body: BlocListener<CommentBloc, CommentState>(
        listener: (context, state) {
          if (state is CommentLoaded) {
            _refreshCompleter?.complete();
            _refreshCompleter = Completer();
          }
        },
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('info goes here ....'),
            ),
            Expanded(
              child: BlocBuilder<CommentBloc, CommentState>(
                builder: (context, state) {
                  if (state is CommentError) {
                    return Center(
                      child: Text('failed to fetch comments'),
                    );
                  }
                  if (state is CommentLoaded) {
                    if (state.comments.isEmpty) {
                      return Center(
                        child: Text('no comments'),
                      );
                    }
                    return RefreshIndicator(
                      key: _refreshIndicatorKey,
                      child: ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return index >= state.comments.length
                              ? BottomLoader()
                              : _buildList(state.comments[index]);
                        },
                        itemCount: state.hasReachedMax
                            ? state.comments.length
                            : state.comments.length + 1,
                        controller: _scrollController,
                      ),
                      onRefresh: () {
                        _commentBloc.dispatch(RefreshComment());
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
            TextFormField(
              controller: _myControllerText,
              keyboardType: TextInputType.text,
              autovalidate: true,
              autocorrect: false,
              autofocus: false,
              decoration: decoration("Enter comment",
                  new Icon(Icons.comment, color: Colors.grey)),
              /*validator: (_) {
                return !state.isEmailValid
                    ? 'Invalid Email'
                    : null;
              },*/
            ),
          ],
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
