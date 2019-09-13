import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_flutter/category/pages/all_categories.dart';
import 'package:todo_flutter/common/pages/settings.dart';
import 'package:todo_flutter/common/services/auth.dart';
import 'package:todo_flutter/common/services/service_locator.dart';
import 'package:todo_flutter/task/bloc/alltodo/bloc.dart';
import 'package:todo_flutter/task/pages/add_todo.dart';
import 'package:todo_flutter/task/pages/all_todo.dart';

class TodoHomePage extends StatefulWidget {
  static const String tag = '/home-page';

  TodoHomePage({Key key, this.newTodo}) : super(key: key);

  final newTodo;

  @override
  TodoState createState() => TodoState();
}

class TodoState extends State<TodoHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String name = services.get<Auth>().getUser()[0];
  String email = services.get<Auth>().getUser()[1];
  static final _controller = PageController();
  final PageStorageBucket bucket = PageStorageBucket();
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  TodoBloc _todoBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (maxScroll - currentScroll <= _scrollThreshold) {
        _todoBloc.dispatch(Fetch());
      }
    });
    _todoBloc = BlocProvider.of<TodoBloc>(context);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _todoBloc.dispose();
    super.dispose();
  }

  bool _onWillPop() {
    if (_controller.page.round() == _controller.initialPage) {
      return true;
    } else {
      _controller.previousPage(
        duration: Duration(milliseconds: 200),
        curve: Curves.linear,
      );
      return false;
    }
  }

  Widget pages() {
    return PageView(
      controller: _controller,
      children: <Widget>[
        AllTodoPage(
          key: PageStorageKey('all-todos'),
          pageController: _controller,
          scrollController: _scrollController,
          todoBloc: _todoBloc,
        ),
        AddTodoPage(
          key: PageStorageKey('add-todo'),
          pageController: _controller,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () => Future.sync(_onWillPop),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                padding: EdgeInsets.all(0.0),
                child: ListView(children: [
                  ListTile(
                    title: UserAccountsDrawerHeader(
                      decoration: BoxDecoration(color: Colors.transparent),
                      accountName: Text(
                        name,
                        style: TextStyle(color: Colors.black),
                      ),
                      accountEmail: Text(
                        email,
                        style: TextStyle(color: Colors.black),
                      ),
                      currentAccountPicture: new CircleAvatar(
                        backgroundColor: Colors.pink,
                        child: Text(name.substring(0, 1).toUpperCase()),
                      ),
                    ),
                    trailing: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: ()  {
                          Navigator.pop(context);
                        }),
                  ),
                ]),
              ),
              ListTile(
                title: Text('Categories'),
                trailing: Icon(Icons.category),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryPage()),
                  );
                },
              ),
              ListTile(
                title: Text('Settings'),
                trailing: Icon(Icons.settings),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                },
              ),
            ],
          ),
        ),
        body: PageStorage(
          child: pages(),
          bucket: bucket,
        ),
      ),
    );
  }
}
