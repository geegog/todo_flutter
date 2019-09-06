
import 'dart:convert';

import 'package:todo_flutter/common/utils/api.dart';
import 'package:todo_flutter/task/domain/model/todo_list.dart';

class TodoRepository {

  Future<TodoList> fetchData(String nextPage) async {
    final response = await APIUtil().fetch(nextPage);
    TodoList todoList = TodoList.fromJson(json.decode(response));
    return todoList;
  }

}