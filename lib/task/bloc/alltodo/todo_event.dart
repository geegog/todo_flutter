import 'package:equatable/equatable.dart';

abstract class TodoEvent extends Equatable {}

class Fetch extends TodoEvent {
  @override
  String toString() => 'Fetch';
}

class Refresh extends TodoEvent {
  @override
  String toString() => 'Refresh';
}