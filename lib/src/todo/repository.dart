import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'todo.dart';

class TodoRepository {
  Future<File> getFile() async {
    final directory = await getApplicationDocumentsDirectory();

    return File("${directory.path}/data.json");
  }

  void saveDate(List<Todo> todoList) async {
    var mappedList = [];
    todoList.forEach((element) {
      mappedList.add({"title": element.title, "ok": element.ok});
    });
    String data = json.encode(mappedList);
    final file = await getFile();
    file.writeAsString(data);
  }

  Future<List<Todo>> readData() async {
    try {
      final file = await getFile();
      var data = await file.readAsString();
      List resultJson = json.decode(data);

      return List.generate(
          resultJson.length, (index) => Todo.fromJson(resultJson[index]));
    } catch (err) {
      return [];
    }
  }
}
