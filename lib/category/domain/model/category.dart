
import 'package:equatable/equatable.dart';

class Category extends Equatable  {

  final String name;

  final int id;

  const Category(this.name, this.id);

  @override
  String toString() => name;

  @override
  List<Object> get props => [name, id];

}