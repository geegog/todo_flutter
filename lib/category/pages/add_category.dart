import 'package:flutter/material.dart';

class AddCategoryPage extends StatefulWidget {
  static const String tag = '/add-category-page';

  AddCategoryPage({Key key}) : super(key: key);

  @override
  AddCategoryState createState() => AddCategoryState();
}

class AddCategoryState extends State<AddCategoryPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Categories'),
      ),
    );
  }
}
