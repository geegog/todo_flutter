
import 'dart:convert';

import 'package:todo_flutter/category/dto/category.dart';
import 'package:todo_flutter/category/dto/category_request.dart';
import 'package:todo_flutter/common/utils/api.dart';

class CategoryRepository {

  Future<String> addCategory({String name}) async {
    Category category = Category(name);

    String categoryRequest = jsonEncode(CategoryRequest(category));

    var response = await APIUtil().post(
        'category/create',
        categoryRequest);

    return response;
  }

}