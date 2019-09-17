
import 'package:todo_flutter/category/domain/model/category.dart';

class CategoryList {
  List<Category> data;


  CategoryList.fromJson(Map<String, dynamic> parsedJson) {
    print(parsedJson['data'].length);
    List<Category> temp = [];
    for (int i = 0; i < parsedJson['data'].length; i++) {
      Map<String, dynamic> jsonData = parsedJson['data'][i];
      Category result = Category(jsonData['name'], jsonData['id']);
      temp.add(result);
    }
    data = temp;
  }

  @override
  String toString() => 'CategoryList { data: ${data.length} }';
}
