import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_flutter/category/domain/model/category.dart';

@immutable
abstract class AddTodoEvent extends Equatable {
  AddTodoEvent([List props = const []]) : super();
}

class TitleChanged extends AddTodoEvent {
  final String title;

  TitleChanged({@required this.title}) : super([title]);

  @override
  String toString() => 'TitleChanged { title :$title }';

  @override
  List<Object> get props => [];
}

class DescriptionChanged extends AddTodoEvent {
  final String description;

  DescriptionChanged({@required this.description}) : super([description]);

  @override
  String toString() => 'DescriptionChanged { description :$description }';

  @override
  List<Object> get props => [];
}

class AddTodoButtonPressed extends AddTodoEvent {
  final String title;
  final String description;
  final DateTime endDate;
  final TimeOfDay endTime;
  final Category category;

  AddTodoButtonPressed(
      {@required this.title,
      @required this.description,
      @required this.endDate,
      @required this.endTime,
      @required this.category})
      : super([title, description, endDate, endTime, category]);

  @override
  String toString() {
    return 'AddTodoButtonPressed { title: $title, description: $description, endDate: $endDate, endTime: $endTime, category: $category}';
  }

  @override
  List<Object> get props => [];
}
