import 'package:todo_flutter/task/domain/model/todo.dart';
import 'package:todo_flutter/user/domain/model/user.dart';

import 'metadata.dart';

class TodoList {
  List<Todo> data;

  MetaData metadata;

  TodoList.fromJson(Map<String, dynamic> parsedJson) {
    print(parsedJson['data'].length);
    metadata = MetaData(
        parsedJson['metadata']['page_number'],
        parsedJson['metadata']['page_size'],
        parsedJson['metadata']['total_entries'],
        parsedJson['metadata']['total_pages']);
    List<Todo> temp = [];
    for (int i = 0; i < parsedJson['data'].length; i++) {
      Map<String, dynamic> jsonData = parsedJson['data'][i];
      User user = User(jsonData['user']['id'], jsonData['user']['email'],
          jsonData['user']['name'], jsonData['user']['phone']);
      Todo result = Todo(jsonData['title'], jsonData['description'],
          jsonData['deadline'], jsonData['id'], user);
      temp.add(result);
    }
    data = temp;
  }

  @override
  String toString() => 'TodoList { metadata: $metadata }';
}
