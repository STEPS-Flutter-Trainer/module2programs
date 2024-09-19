import 'package:get/get.dart';

import '../model/todo.dart';
import 'database_helper.dart';

class TodoController extends GetxController {
  var todos = <Todo>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTodos();
  }

  void fetchTodos() async {
    todos.value = await DatabaseHelper().getTodos();
  }

  void addTodo(String title) async {
    final todo = Todo(title: title);
    await DatabaseHelper().insertTodo(todo);
    fetchTodos();
  }

  void updateTodoStatus(Todo todo) async {
    todo.isDone = !todo.isDone;
    await DatabaseHelper().updateTodo(todo);
    fetchTodos();
  }

  void deleteTodo(int id) async {
    await DatabaseHelper().deleteTodo(id);
    fetchTodos();
  }
}
