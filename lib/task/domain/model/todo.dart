
import 'package:equatable/equatable.dart';
import 'package:todo_flutter/user/domain/model/user.dart';

class Todo extends Equatable  {

  final String deadline;

  final String description;

  final String title;

  final int id;

  Todo(this.title, this.description, this.deadline, this.id) : super([deadline, description, title, id]);

}