import 'package:flutter/material.dart';
import 'package:todo_flutter/category/pages/add_category.dart';

class CategoryPage extends StatefulWidget {
  static const String tag = '/all-category-page';

  CategoryPage({Key key}) : super(key: key);

  @override
  CategoryState createState() => CategoryState();
}

class CategoryState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('All Categories'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_circle,
              color: Colors.white,
              semanticLabel: 'add category',
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCategoryPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
