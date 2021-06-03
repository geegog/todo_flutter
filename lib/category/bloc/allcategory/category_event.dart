import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchCategory extends CategoryEvent {
  @override
  String toString() => 'FetchCategory';
}

class RefreshCategory extends CategoryEvent {
  @override
  String toString() => 'RefreshCategory';
}