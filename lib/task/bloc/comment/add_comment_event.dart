import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_flutter/category/domain/model/category.dart';

@immutable
abstract class AddCommentEvent extends Equatable {
  AddCommentEvent([List props = const []]) : super();
}

class TextChanged extends AddCommentEvent {
  final String text;

  TextChanged({@required this.text}) : super([text]);

  @override
  String toString() => 'TextChanged { text :$text }';

  @override
  List<Object> get props => [];
}

class AddCommentButtonPressed extends AddCommentEvent {
  final String text;
  final int todoId;

  AddCommentButtonPressed({
    @required this.text,
    @required this.todoId,
  }) : super([text, todoId]);

  @override
  String toString() {
    return 'AddCommentButtonPressed { text: $text, todoId: $todoId }';
  }

  @override
  List<Object> get props => [];
}
