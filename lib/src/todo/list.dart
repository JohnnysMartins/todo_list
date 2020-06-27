import 'dart:convert';

import 'package:flutter/material.dart';
import 'repository.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final newItemController = TextEditingController();
  List todoList = [];
  final repository = TodoRepository();

  Future refresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      todoList.sort((a, b) {
        if (a["ok"] && !b["ok"]) return 1;
        if (!a["ok"] && b["ok"]) return -1;
        return 0;
      });
    });
    repository.saveDate(todoList);
  }

//  @override
//  void initState() {
//    super.initState();
//
//    getData().then((data) => {todoList = data});
//  }

  Future getData() async {
    await Future.delayed(Duration(seconds: 2));
    String data = await repository.readData();
    return json.decode(data);
  }

  void addTodo() {
    setState(() {
      Map<String, dynamic> newItem = Map();
      newItem["title"] = newItemController.text;
      newItem["ok"] = false;
      newItemController.clear();
      todoList.add(newItem);
      repository.saveDate(todoList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("can't retrieve data"));
        }

        if (snapshot.hasData) {
          todoList = snapshot.data;
          return Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: newItemController,
                        decoration: InputDecoration(
                            labelText: "New Item",
                            labelStyle: TextStyle(color: Colors.blueAccent)),
                      ),
                    ),
                    RaisedButton(
                      color: Colors.blueAccent,
                      child: Text("ADD"),
                      textColor: Colors.white,
                      onPressed: addTodo,
                    )
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: refresh,
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 10.0),
                    itemCount: todoList.length,
                    itemBuilder: buildItem,
                  ),
                ),
              )
            ],
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget buildItem(context, index) {
    return Dismissible(
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      key: UniqueKey(),
      child: CheckboxListTile(
        title: Text(todoList[index]["title"]),
        value: todoList[index]["ok"],
        secondary: CircleAvatar(
          child: Icon(todoList[index]["ok"] ? Icons.check : Icons.error),
        ),
        onChanged: (value) {
          setState(() {
            todoList[index]["ok"] = value;
            repository.saveDate(todoList);
          });
        },
      ),
      onDismissed: (direction) {
        Map<String, dynamic> lastRemoved;
        setState(() {
          lastRemoved = Map.from(todoList[index]);
          todoList.removeAt(index);
          repository.saveDate(todoList);
        });
        final snack = SnackBar(
          content: Text("Item ${lastRemoved["title"]} removed"),
          action: SnackBarAction(
            label: "undo",
            onPressed: () {
              setState(() {
                todoList.insert(index, lastRemoved);
                repository.saveDate(todoList);
              });
            },
          ),
          duration: Duration(seconds: 3),
        );
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(snack);
      },
    );
  }
}
