import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class AddTodoEvent extends Equatable {
  AddTodoEvent([List props = const []]) : super(props);
}

class TitleChanged extends AddTodoEvent {
  final String title;

  TitleChanged({@required this.title}) : super([title]);

  @override
  String toString() => 'TitleChanged { title :$title }';
}

class DescriptionChanged extends AddTodoEvent {
  final String description;

  DescriptionChanged({@required this.description}) : super([description]);

  @override
  String toString() => 'DescriptionChanged { description :$description }';
}

class AddTodoButtonPressed extends AddTodoEvent {
  final String title;
  final String description;
  final DateTime endDate;
  final TimeOfDay endTime;

  AddTodoButtonPressed(
      {@required this.title,
      @required this.description,
      @required this.endDate,
      @required this.endTime})
      : super([title, description, endDate, endTime]);

  @override
  String toString() {
    return 'AddTodoButtonPressed { title: $title, description: $description, _endDate: $endDate , endTime: $endTime}';
  }
}
