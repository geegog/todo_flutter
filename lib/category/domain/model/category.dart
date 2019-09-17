
import 'package:equatable/equatable.dart';

class Category extends Equatable  {

  final String name;

  final int id;

  Category(this.name, this.id) : super([name, id]);

}