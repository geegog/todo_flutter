import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:todo_flutter/common/services/auth.dart';
import 'package:todo_flutter/common/services/service_locator.dart';
import 'package:todo_flutter/common/utils/api.dart';
import 'package:todo_flutter/task/domain/model/todo_list.dart';
import 'package:todo_flutter/task/dto/todo.dart';
import 'package:todo_flutter/task/dto/todo_request.dart';

class TodoRepository {
  Future<TodoList> fetchData(String nextPage) async {
    final response = await APIUtil().fetch(nextPage);
    TodoList todoList = TodoList.fromJson(json.decode(response));
    return todoList;
  }

  Future<String> addTodo({
    @required String title,
    @required String description,
    @required DateTime endDate,
    @required TimeOfDay endTime,
    @required String datetime,
  }) async {

    Todo todo = Todo(datetime, description, title);

    String todoRequest = jsonEncode(TodoRequest(todo));

    var response = await APIUtil().post(
        'todo/user/' + services.get<Auth>().getUserId() + '/create',
        todoRequest);

    return response;

  }
}
