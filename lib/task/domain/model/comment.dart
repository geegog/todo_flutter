
import 'package:equatable/equatable.dart';

class Comment extends Equatable {

  Comment(this.text, this.id) : super([text, id]);

  final String text;

  final int id;

}