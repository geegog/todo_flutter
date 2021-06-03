import 'package:equatable/equatable.dart';

abstract class CommentEvent extends Equatable {
  CommentEvent([List props = const []]) : super();
}

class FetchComment extends CommentEvent {
  FetchComment({this.todoId}) : super();

  final int todoId;

  @override
  String toString() => 'FetchComment';

  @override
  List<Object> get props => [];
}

class RefreshComment extends CommentEvent {
  RefreshComment({this.todoId}) : super();

  final int todoId;
  @override
  String toString() => 'RefreshComment';

  @override
  List<Object> get props => [];
}
