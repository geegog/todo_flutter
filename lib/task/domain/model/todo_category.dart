
import 'package:equatable/equatable.dart';
import 'package:todo_flutter/category/domain/model/category.dart';
import 'package:todo_flutter/task/domain/model/todo.dart';

class TodoCategory extends Equatable {

  final Category category;

  final Todo todo;

  final int id;

  final int commentsCount;

  const TodoCategory(this.category, this.todo, this.id, this.commentsCount);

  @override
  List<Object> get props => [category, todo, id, commentsCount];

}