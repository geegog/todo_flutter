import 'package:json_annotation/json_annotation.dart';
import 'user.dart';

part 'user_request.g.dart';

@JsonSerializable(explicitToJson: true)
class UserRequest {
  UserRequest(this.user);

  User user;

  factory UserRequest.fromJson(Map<String, dynamic> json) => _$UserRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UserRequestToJson(this);
}