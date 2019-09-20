import 'package:todo_flutter/category/domain/model/category.dart';
import 'package:todo_flutter/task/domain/model/todo.dart';
import 'package:todo_flutter/task/domain/model/todo_category.dart';
import 'package:todo_flutter/user/domain/model/user.dart';

import 'metadata.dart';

class TodoList {
  List<TodoCategory> data;

  MetaData metadata;

  TodoList.fromJson(Map<String, dynamic> parsedJson) {
    print(parsedJson['data'].length);
    metadata = MetaData(
        parsedJson['metadata']['page_number'],
        parsedJson['metadata']['page_size'],
        parsedJson['metadata']['total_entries'],
        parsedJson['metadata']['total_pages']);
    List<TodoCategory> temp = [];
    for (int i = 0; i < parsedJson['data'].length; i++) {
      Map<String, dynamic> jsonData = parsedJson['data'][i];
      Category category = Category(jsonData['category']['name'], jsonData['category']['id'],);
      Todo todo = Todo(jsonData['todo']['title'], jsonData['todo']['description'], jsonData['todo']['deadline'], jsonData['todo']['id'],);
      TodoCategory result = TodoCategory(category, todo, jsonData['id']);
      temp.add(result);
    }
    data = temp;
  }

  @override
  String toString() => 'TodoList { metadata: $metadata }';
}
