import 'package:equatable/equatable.dart';

abstract class CommentEvent extends Equatable {}

class FetchComment extends CommentEvent {

  FetchComment({this.todoId}) : super();

  final int todoId;

  @override
  String toString() => 'FetchComment';
}

class RefreshComment extends CommentEvent {

  @override
  String toString() => 'RefreshComment';
}