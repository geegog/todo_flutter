import 'package:equatable/equatable.dart';
import 'package:todo_flutter/task/domain/model/todo_category.dart';

abstract class TodoState extends Equatable {
  TodoState([List props = const []]) : super(props);
}

class TodoUninitialized extends TodoState {
  @override
  String toString() => 'TodoUninitialized';
}

class TodoError extends TodoState {
  @override
  String toString() => 'TodoError';
}

class TodoLoaded extends TodoState {
  final List<TodoCategory> todos;
  final bool hasReachedMax;
  final DateTime dateTime;

  TodoLoaded({
    this.todos,
    this.hasReachedMax,
    this.dateTime,
  }) : super([todos, hasReachedMax, dateTime]);

  TodoLoaded copyWith({
    List<TodoCategory> todos,
    bool hasReachedMax,
    DateTime dateTime,
  }) {
    return TodoLoaded(
      todos: todos ?? this.todos,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      dateTime: dateTime,
    );
  }

  @override
  String toString() =>
      'TodoLoaded { todos: ${todos.length}, hasReachedMax: $hasReachedMax }';
}
