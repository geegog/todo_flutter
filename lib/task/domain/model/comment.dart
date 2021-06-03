
import 'package:equatable/equatable.dart';
import 'package:todo_flutter/task/domain/model/todo.dart';
import 'package:todo_flutter/user/domain/model/user.dart';

class Comment extends Equatable {

  const Comment(this.text, this.id, this.todo, this.user);

  final String text;

  final int id;

  final Todo todo;

  final User user;

  @override
  List<Object> get props => [text, id, todo, user];

}