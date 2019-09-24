import 'package:json_annotation/json_annotation.dart';
import 'package:todo_flutter/task/dto/comment.dart';
import 'comment.dart';

part 'comment_request.g.dart';

@JsonSerializable(explicitToJson: true)
class CommentRequest {
  CommentRequest(this.comment);

  Comment comment;

  factory CommentRequest.fromJson(Map<String, dynamic> json) =>
      _$CommentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CommentRequestToJson(this);
}