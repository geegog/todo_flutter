// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryRequest _$CategoryRequestFromJson(Map<String, dynamic> json) {
  return CategoryRequest(json['category'] == null
      ? null
      : Category.fromJson(json['category'] as Map<String, dynamic>));
}

Map<String, dynamic> _$CategoryRequestToJson(CategoryRequest instance) =>
    <String, dynamic>{'category': instance.category?.toJson()};
