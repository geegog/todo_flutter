import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_flutter/common/pages/login.dart';
import 'package:todo_flutter/common/services/auth.dart';
import 'package:todo_flutter/common/services/service_locator.dart';
import 'package:todo_flutter/common/components/router.dart' as router;

class HomePage extends StatelessWidget {
  static const String tag = '/home-page';
  final argument;
  const HomePage({Key key, this.argument}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo Home',
      theme: ThemeData(primaryColor: Colors.green),
      home: Todo(),
      onGenerateRoute: router.privateRoute,
    );
  }
}

class Todo extends StatefulWidget {
  @override
  TodoState createState() => TodoState();
}

class TodoState extends State<Todo> {

  static String name = services.get<Auth>().getUser()[0];
  static String email = services.get<Auth>().getUser()[1];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print('home');
    return Scaffold(
      appBar: AppBar(
        title: Text('Todos'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.today,
              color: Colors.white,
              semanticLabel: 'add todo',
            ),
            onPressed: () {},
          ),
        ],
      ),
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
                print('kkkkk');
                Navigator.pushReplacementNamed(context, LoginPage.tag);
              },
            )
          ],
        ),
      ),
    );
  }
}
