// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoRequest _$TodoRequestFromJson(Map<String, dynamic> json) {
  return TodoRequest(json['todo'] == null
      ? null
      : Todo.fromJson(json['todo'] as Map<String, dynamic>));
}

Map<String, dynamic> _$TodoRequestToJson(TodoRequest instance) =>
    <String, dynamic>{'todo': instance.todo?.toJson()};
