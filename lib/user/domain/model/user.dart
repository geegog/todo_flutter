
import 'package:equatable/equatable.dart';

class User extends Equatable {

  final String name;

  final String email;

  final String phone;

  final int id;

  User(this.id, this.email, this.name, this.phone) : super([id, email, name, phone]);

}