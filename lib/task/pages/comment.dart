import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_flutter/task/bloc/comment/bloc.dart';
import 'package:todo_flutter/task/domain/model/comment.dart';
import 'package:todo_flutter/task/domain/model/todo_category.dart';
import 'package:todo_flutter/task/widget/side_line.dart' as line;
import 'package:todo_flutter/common/utils/date_time.dart' as dateTimeUtil;

class CommentPage extends StatefulWidget {
  static const String tag = '/todo-comments';

  CommentPage({Key key, this.todoCategory}) : super(key: key);

  final TodoCategory todoCategory;

  @override
  CommentPageState createState() => new CommentPageState();
}

class CommentPageState extends State<CommentPage> {
  Completer<void> _refreshCompleter;

  final TextEditingController _myControllerText = TextEditingController();
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  CommentBloc _commentBloc;
  AddCommentBloc _addCommentBloc;

  final Function decoration = (String text, Icon icon) => InputDecoration(
        prefixIcon: icon,
        hintText: text,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
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
    _addCommentBloc = BlocProvider.of<AddCommentBloc>(context);
    _myControllerText.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    _addCommentBloc.dispatch(
      TextChanged(text: _myControllerText.text),
    );
  }

  bool get isPopulated => _myControllerText.text.isNotEmpty;

  bool isAddCommentButtonEnabled(AddCommentState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  void _onFormSubmitted() {
    _addCommentBloc.dispatch(
      AddCommentButtonPressed(
          text: _myControllerText.text, todoId: widget.todoCategory.todo.id),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _myControllerText.dispose();
  }

  Widget _buildList(Comment comment) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      comment.user.name,
                      style: TextStyle(color: Colors.black, fontSize: 20.0),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      comment.text,
                      style: TextStyle(color: Colors.grey, fontSize: 15.0),
                    ),
                  ),
                ],
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
      bottomNavigationBar: Container(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: BlocListener<AddCommentBloc, AddCommentState>(
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
                          Text('Adding Todo...'),
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
                      duration: Duration(seconds: 3),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Comment added successfully ...'),
                          Icon(Icons.check)
                        ],
                      ),
                    ),
                  );
              }
            },
            child: BlocBuilder<AddCommentBloc, AddCommentState>(
              builder: (context, state) {
                return Form(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          controller: _myControllerText,
                          keyboardType: TextInputType.text,
                          autovalidate: true,
                          autocorrect: false,
                          autofocus: false,
                          decoration: decoration("Enter comment",
                              new Icon(Icons.comment, color: Colors.grey)),
                        ),
                      ),
                      LimitedBox(
                        maxWidth: 50.0,
                        child: IconButton(
                            icon: Icon(Icons.send),
                            onPressed: isAddCommentButtonEnabled(state)
                                ? _onFormSubmitted
                                : null),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
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
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Container(
                          color: line.color(widget.todoCategory.todo.deadline),
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
                                            color: line.color(widget
                                                .todoCategory.todo.deadline)),
                                        SizedBox(
                                          width: 8.0,
                                        ),
                                        Expanded(
                                          child: Text(
                                            widget.todoCategory.todo.title,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        dateTimeUtil.formatDateTime(
                                            widget.todoCategory.todo.deadline),
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 10.0),
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
                                    widget.todoCategory.todo.description,
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 15.0),
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
                                    onPressed: () {},
                                  ),
                                  Text(
                                    '${widget.todoCategory.commentsCount}',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 18.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<CommentBloc, CommentState>(
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
                        return ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return index >= state.comments.length
                                ? BottomLoader()
                                : _buildList(state.comments[index]);
                          },
                          itemCount: state.hasReachedMax
                              ? state.comments.length
                              : state.comments.length + 1,
                          controller: _scrollController,
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ],
              ),
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
