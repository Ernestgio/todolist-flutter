import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist/todo.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database _db;

  DatabaseHelper._instance();

  String todoTable = 'todo_table';
  String colId = 'id';
  String colName = 'name';
  String colTodoTime = 'todo_time';
  String colTodoDate = 'todo_date';
  String colColorTag = 'color_tag';
  String colIsFinalized = 'is_finalized';
  String colDescription = 'description';

  Future<Database> _initDb() async{
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'todo_list.db';
    final todoListDb = await openDatabase(path, version: 1, onCreate: _createDb);
    return todoListDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute('CREATE TABLE $todoTable('
        '$colId INTEGER PRIMARY KEY AUTOINCREMENT, '+
        '$colName TEXT, '+
        '$colTodoTime TEXT, ' +
        '$colTodoDate TEXT, ' +
        '$colColorTag INTEGER, '+
        '$colIsFinalized INTEGER, '+
        '$colDescription TEXT)');
  }

  Future<Database> get db async {
    if(_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  Future<List<Map<String, dynamic>>> getTodoMapList() async {
    Database db = await this.db;
    final List<Map<String,dynamic>> result = await db.query(todoTable);
    return result;
  }

  Future<List<Todo>> getTodoList() async {
    final List<Map<String, dynamic>> todoMapList = await getTodoMapList();
    final List<Todo> todoList = [];

    todoMapList.forEach((todoMap) {
      todoList.add(Todo.fromMap(todoMap));
    });
    return todoList;
  }

  Future<List<Todo>> searchTodoList(queryString) async {
    Database db = await this.db;

    final List<Map<String,dynamic>> result = await db.query('$todoTable', where: "$colName LIKE ?", whereArgs: ['%$queryString%']);
    final List<Todo> todoList = [];

    result.forEach((todoMap) {
      todoList.add(Todo.fromMap(todoMap));
    });

    return todoList;
}

  Future<List<Todo>> getDoneTodoList() async {
    final List<Map<String, dynamic>> todoMapList = await getTodoMapList();
    final List<Todo> todoList = [];

    todoMapList.forEach((todoMap) {
          if(todoMap['is_finalized'] == 1){
            todoList.add(Todo.fromMap(todoMap));
          }
    });
    return todoList;
  }

  Future<int> insertTodo(Todo todo) async {
    Database db = await this.db;
    final int result = await db.insert(todoTable, todo.toMap());
    return result;
  }

  Future updateTodo(Todo todo) async {
    Database db = await this.db;
    final int result = await db.update(todoTable, todo.toMap(), where: '$colId = ?', whereArgs: [todo.id]);
    return result;

  }
}