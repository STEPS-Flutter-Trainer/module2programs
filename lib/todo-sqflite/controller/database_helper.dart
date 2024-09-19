import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/todo.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'todo.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE todos(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, isDone INTEGER)',
        );
      },
    );
  }

  Future<List<Todo>> getTodos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('todos');
    return List.generate(maps.length, (i) => Todo.fromMap(maps[i]));
  }

  Future<void> insertTodo(Todo todo) async {
    final db = await database;
    await db.insert('todos', todo.toMap());
  }

  Future<void> updateTodo(Todo todo) async {
    final db = await database;
    await db.update('todos', todo.toMap(), where: 'id = ?', whereArgs: [todo.id]);
  }

  Future<void> deleteTodo(int id) async {
    final db = await database;
    await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }
}
