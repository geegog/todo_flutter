import 'package:json_annotation/json_annotation.dart';

part 'jwt.g.dart';

@JsonSerializable()
class Jwt {
  Jwt(this.jwt);

  String jwt;

  factory Jwt.fromJson(Map<String, dynamic> json) => _$JwtFromJson(json);

  Map<String, dynamic> toJson() => _$JwtToJson(this);
}
