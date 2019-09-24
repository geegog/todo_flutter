// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentRequest _$CommentRequestFromJson(Map<String, dynamic> json) {
  return CommentRequest(json['comment'] == null
      ? null
      : Comment.fromJson(json['comment'] as Map<String, dynamic>));
}

Map<String, dynamic> _$CommentRequestToJson(CommentRequest instance) =>
    <String, dynamic>{'comment': instance.comment?.toJson()};
