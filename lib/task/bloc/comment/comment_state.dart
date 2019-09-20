import 'package:equatable/equatable.dart';
import 'package:todo_flutter/task/domain/model/comment.dart';

abstract class CommentState extends Equatable {
  CommentState([List props = const []]) : super(props);
}

class CommentUninitialized extends CommentState {
  @override
  String toString() => 'CommentUninitialized';
}

class CommentError extends CommentState {
  @override
  String toString() => 'CommentError';
}

class CommentLoaded extends CommentState {
  final List<Comment> comments;
  final bool hasReachedMax;
  final DateTime dateTime;

  CommentLoaded({
    this.comments,
    this.hasReachedMax,
    this.dateTime,
  }) : super([comments, hasReachedMax, dateTime]);

  CommentLoaded copyWith({
    List<Comment> comments,
    bool hasReachedMax,
    DateTime dateTime,
  }) {
    return CommentLoaded(
      comments: comments ?? this.comments,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      dateTime: dateTime,
    );
  }

  @override
  String toString() =>
      'CommentLoaded { comments: ${comments.length}, hasReachedMax: $hasReachedMax }';
}
