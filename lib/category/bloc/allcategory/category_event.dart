import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {}

class Fetch extends CategoryEvent {
  @override
  String toString() => 'Fetch';
}

class Refresh extends CategoryEvent {
  @override
  String toString() => 'Refresh';
}