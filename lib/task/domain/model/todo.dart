
import 'package:equatable/equatable.dart';

class Todo extends Equatable  {

  final String deadline;

  final String description;

  final String title;

  final int id;

  const Todo(this.title, this.description, this.deadline, this.id);

  @override
  List<Object> get props => [title, description, deadline, id];

}