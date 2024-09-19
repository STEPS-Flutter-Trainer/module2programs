import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:module2programs/todo-sqflite/view/todo-view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: TodoPage(),
    );
  }
}
