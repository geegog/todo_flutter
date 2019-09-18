import 'package:equatable/equatable.dart';
import 'package:todo_flutter/category/domain/model/category.dart';

abstract class CategoryState extends Equatable {
  CategoryState([List props = const []]) : super(props);
}

class CategoryUninitialized extends CategoryState {
  @override
  String toString() => 'CategoryUninitialized';
}

class CategoryError extends CategoryState {
  @override
  String toString() => 'CategoryError';
}

class CategoryLoaded extends CategoryState {
  final List<Category> categories;
  final bool hasReachedMax;
  final DateTime dateTime;

  CategoryLoaded({
    this.categories,
    this.hasReachedMax,
    this.dateTime,
  }) : super([categories, hasReachedMax, dateTime]);

  CategoryLoaded copyWith({
    List<Category> categories,
    bool hasReachedMax,
    DateTime dateTime,
  }) {
    return CategoryLoaded(
      categories: categories ?? this.categories,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      dateTime: dateTime,
    );
  }

  @override
  String toString() =>
      'CategoryLoaded { todos: ${categories.length}, hasReachedMax: $hasReachedMax }';
}
