import 'package:flutter/material.dart';
import 'todo/list.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("TODO LIST"),
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
        ),
        body: TodoList(),
      ),
    );
  }
}
