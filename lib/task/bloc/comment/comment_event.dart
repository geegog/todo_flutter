import 'package:equatable/equatable.dart';

abstract class CommentEvent extends Equatable {
  CommentEvent([List props = const []]) : super(props);
}

class FetchComment extends CommentEvent {
  FetchComment({this.todoId}) : super();

  final int todoId;

  @override
  String toString() => 'FetchComment';
}

class RefreshComment extends CommentEvent {
  RefreshComment({this.todoId}) : super();

  final int todoId;
  @override
  String toString() => 'RefreshComment';
}
