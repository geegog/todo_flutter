
import 'package:equatable/equatable.dart';

class User extends Equatable {

  final String name;

  final String email;

  final String phone;

  final int id;

  const User(this.id, this.email, this.name, this.phone);

  @override
  List<Object> get props => [id, email, name, phone];

}