import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class AddCategoryEvent extends Equatable {
  AddCategoryEvent([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class NameChanged extends AddCategoryEvent {
  final String name;

  NameChanged({@required this.name}) : super([name]);

  @override
  String toString() => 'NameChanged { name :$name }';
}

class AddCategoryButtonPressed extends AddCategoryEvent {
  final String name;

  AddCategoryButtonPressed({@required this.name}) : super([name]);

  @override
  String toString() {
    return 'AddCategoryButtonPressed { name: $name }';
  }
}
