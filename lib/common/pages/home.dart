import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_flutter/common/pages/login.dart';
import 'package:todo_flutter/common/services/auth.dart';
import 'package:todo_flutter/common/services/service_locator.dart';
import 'package:todo_flutter/task/pages/add_todo.dart';
import 'package:todo_flutter/task/pages/all_todo.dart';

class TodoHomePage extends StatefulWidget {

  static const String tag = '/home-page';

  const TodoHomePage({Key key}) : super(key: key);

  @override
  TodoState createState() => TodoState();
}

class TodoState extends State<TodoHomePage> {
  static String name = services.get<Auth>().getUser()[0];
  static String email = services.get<Auth>().getUser()[1];
  static final _controller = PageController();

  bool _onWillPop() {
    _controller.previousPage(
      duration: Duration(milliseconds: 200),
      curve: Curves.linear,
    );
    return (_controller.page.round() == _controller.initialPage) ? true : false;
  }

  final pageView = PageView(
    controller: _controller,
    children: <Widget>[AllTodoPage(), AddTodoPage()],
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print('home');
    return WillPopScope(
      onWillPop: () => Future.sync(_onWillPop),
      child: Scaffold(
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
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ),
                ]),
              ),
              ListTile(
                title: Text('Logout'),
                trailing: Icon(Icons.power_settings_new),
                onTap: () {
                  services.get<Auth>().removeUser();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              )
            ],
          ),
        ),
        body: pageView,
      ),
    );
  }
}
