
import 'package:equatable/equatable.dart';
import 'package:todo_flutter/task/domain/model/todo.dart';
import 'package:todo_flutter/user/domain/model/user.dart';

class Comment extends Equatable {

  Comment(this.text, this.id, this.todo, this.user) : super([text, id, todo, user]);

  final String text;

  final int id;

  final Todo todo;

  final User user;

}