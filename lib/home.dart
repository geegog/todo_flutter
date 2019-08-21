import 'package:flutter/material.dart';

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
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Logout'),
              trailing: Icon(Icons.power_settings_new),
              onTap: (){
                
              },
            )
          ],
        ),
      ),
    );
  }
}
