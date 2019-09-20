import 'package:equatable/equatable.dart';

abstract class CommentEvent extends Equatable {}

class FetchComment extends CommentEvent {
  @override
  String toString() => 'FetchComment';
}

class RefreshComment extends CommentEvent {
  @override
  String toString() => 'RefreshComment';
}