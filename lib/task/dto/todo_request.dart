import 'package:json_annotation/json_annotation.dart';
import 'todo.dart';

part 'todo_request.g.dart';

@JsonSerializable(explicitToJson: true)
class TodoRequest {
  TodoRequest(this.todo);

  Todo todo;

  factory TodoRequest.fromJson(Map<String, dynamic> json) =>
      _$TodoRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TodoRequestToJson(this);
}
