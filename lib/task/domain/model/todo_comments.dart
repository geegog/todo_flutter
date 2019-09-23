import 'package:todo_flutter/task/domain/model/comment.dart';
import 'package:todo_flutter/task/domain/model/metadata.dart';
import 'package:todo_flutter/task/domain/model/todo.dart';
import 'package:todo_flutter/user/domain/model/user.dart';

class TodoComments {
  List<Comment> data;

  MetaData metadata;

  TodoComments.fromJson(Map<String, dynamic> parsedJson) {
    print(parsedJson['data'].length);
    metadata = MetaData(
        parsedJson['metadata']['page_number'],
        parsedJson['metadata']['page_size'],
        parsedJson['metadata']['total_entries'],
        parsedJson['metadata']['total_pages']);
    List<Comment> temp = [];
    for (int i = 0; i < parsedJson['data'].length; i++) {
      Map<String, dynamic> jsonData = parsedJson['data'][i];
      Todo todo = Todo(
          jsonData['todo']['title'],
          jsonData['todo']['description'],
          jsonData['todo']['deadline'],
          jsonData['todo']['id']);
      User user = User(jsonData['user']['id'], jsonData['user']['email'],
          jsonData['user']['name'], jsonData['user']['phone']);
      Comment result = Comment(jsonData['text'], jsonData['id'], todo, user);
      temp.add(result);
    }
    data = temp;
  }

  @override
  String toString() => 'TodoComments { metadata: $metadata }';
}
