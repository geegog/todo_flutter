import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_flutter/common/services/storage.dart';
import 'package:todo_flutter/common/pages/login.dart';
import 'package:todo_flutter/common/services/service_locator.dart';

class HomePage extends StatelessWidget {
  static String tag = '/home-page';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo Home',
      theme: ThemeData(primaryColor: Colors.green),
      home: Todo(),
    );
  }
}

class Todo extends StatefulWidget {
  @override
  TodoState createState() => TodoState();
}

class TodoState extends State<Todo> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Todos'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.today, color: Colors.white, semanticLabel: 'add todo',)),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(child: Container()),
            ListTile(
              title: Text('Logout'),
              trailing: Icon(Icons.power_settings_new),
              onTap: () {
                services.get<Storage>().removeToken();
                Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(builder: (context) => LoginPage()),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
