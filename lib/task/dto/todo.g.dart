// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Todo _$TodoFromJson(Map<String, dynamic> json) {
  return Todo(json['deadline'] as String, json['description'] as String,
      json['title'] as String);
}

Map<String, dynamic> _$TodoToJson(Todo instance) => <String, dynamic>{
      'deadline': instance.deadline,
      'description': instance.description,
      'title': instance.title
    };
