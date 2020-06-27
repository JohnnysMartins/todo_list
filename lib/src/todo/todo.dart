
class Todo {
  String title;
  bool ok;

  Todo(this.title, this.ok);

  Todo.fromJson(Map<String, dynamic> json) {
    this.title = json['title'];
    this.ok = json['ok'];
  }
}