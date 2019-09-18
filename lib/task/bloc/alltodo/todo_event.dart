import 'package:equatable/equatable.dart';

abstract class TodoEvent extends Equatable {}

class FetchTodo extends TodoEvent {
  @override
  String toString() => 'FetchTodo';
}

class RefreshTodo extends TodoEvent {
  @override
  String toString() => 'RefreshTodo';
}