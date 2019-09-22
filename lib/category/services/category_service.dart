import 'package:todo_flutter/category/domain/repository/category_repository.dart';

class CategoryService {
  final _categoryRepository = CategoryRepository();

  getCategories() async {
    final categories = await _categoryRepository.fetchData('category/all');
    return categories.data;
  }


}
