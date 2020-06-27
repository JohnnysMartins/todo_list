import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class TodoRepository {
  Future<File> getFile() async {
    final directory = await getApplicationDocumentsDirectory();

    return File("${directory.path}/data.json");
  }

  void saveDate(List todoList) async {
    String data = json.encode(todoList);
    final file = await getFile();
    file.writeAsString(data);
  }

  Future<String> readData() async {
    try {
      final file = await getFile();

      return file.readAsString();
    } catch (err) {
      print(err);
      return null;
    }
  }
}
