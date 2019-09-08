import 'package:equatable/equatable.dart';
import 'package:todo_flutter/task/domain/model/todo.dart';

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
  final List<Todo> todos;
  final bool hasReachedMax;

  TodoLoaded({
    this.todos,
    this.hasReachedMax,
  }) : super([todos, hasReachedMax]);

  TodoLoaded copyWith({
    List<Todo> todos,
    bool hasReachedMax,
  }) {
    return TodoLoaded(
      todos: todos ?? this.todos,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() =>
      'TodoLoaded { todos: ${todos.length}, hasReachedMax: $hasReachedMax }';
}
