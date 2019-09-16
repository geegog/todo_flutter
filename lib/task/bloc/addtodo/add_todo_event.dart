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
  final String datetime;

  AddTodoButtonPressed(
      {@required this.title,
      @required this.description,
      @required this.datetime})
      : super([title, description, datetime]);

  @override
  String toString() {
    return 'AddTodoButtonPressed { title: $title, description: $description, datetime: $datetime }';
  }
}
