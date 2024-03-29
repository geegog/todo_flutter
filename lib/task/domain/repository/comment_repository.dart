import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:todo_flutter/category/domain/model/category.dart';

import 'package:todo_flutter/common/services/auth.dart';
import 'package:todo_flutter/common/services/service_locator.dart';
import 'package:todo_flutter/common/utils/api.dart';
import 'package:todo_flutter/task/domain/model/todo_comments.dart';
import 'package:todo_flutter/task/dto/comment.dart';
import 'package:todo_flutter/task/dto/comment_request.dart';

class CommentRepository {
  Future<TodoComments> fetchData(String nextPage) async {
    final response = await APIUtil().fetch(nextPage);
    TodoComments todoComments = TodoComments.fromJson(json.decode(response));
    return todoComments;
  }

  Future<String> addComment({
    @required String text,
    @required int todoId,
  }) async {

    Comment comment = Comment(text);

    CommentRequest commentRequest = CommentRequest(comment);

    String request = jsonEncode(commentRequest);

    var response = await APIUtil().post(
        'comment/user/' + services.get<Auth>().getUserId() + '/todo/' + todoId.toString() + '/create',
        request);

    return response;

  }
}
