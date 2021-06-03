import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_flutter/category/bloc/allcategory/bloc.dart';
import 'package:todo_flutter/category/pages/add_category.dart';

class CategoryPage extends StatefulWidget {
  static const String tag = '/all-category-page';

  CategoryPage({Key key}) : super(key: key);

  @override
  CategoryPageState createState() => CategoryPageState();
}

class CategoryPageState extends State<CategoryPage> {
  Completer<void> _refreshCompleter;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  CategoryBloc _categoryBloc;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    _categoryBloc = BlocProvider.of<CategoryBloc>(context);
    _categoryBloc..add(FetchCategory());
  }

  @override
  void dispose() {
    super.dispose();
  }

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
      body: BlocListener<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state is CategoryLoaded) {
            _refreshCompleter?.complete();
            _refreshCompleter = Completer();
          }
        },
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            print(state);
            if (state is CategoryError) {
              return Center(
                child: Text('failed to fetch categories'),
              );
            }
            if (state is CategoryLoaded) {
              if (state.categories.isEmpty) {
                return Center(
                  child: Text('no categories'),
                );
              }
              return RefreshIndicator(
                key: _refreshIndicatorKey,
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  children: List.generate(state.categories.length, (index) {
                    return Card(
                      child: Center(
                        child: Text(
                          state.categories[index].name,
                          style: Theme.of(context).textTheme.headline,
                        ),
                      ),
                    );
                  }),
                ),
                onRefresh: () {
                  _categoryBloc.add(RefreshCategory());
                  return _refreshCompleter.future;
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
