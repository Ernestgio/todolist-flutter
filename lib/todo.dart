import 'package:flutter/material.dart';

class Todo {
  int id;
  String name;
  String description;
  int colorTag;
  int isFinalized;
  DateTime todoDate;
  String todoTime;

  static const int GREEN_COLOR = 1;
  static const int ORANGE_COLOR = 2;
  static const int BLUE_COLOR = 3;
  static const int YELLOW_COLOR = 4;

  Todo({this.name, this.todoDate, this.todoTime, this.colorTag, this.isFinalized, this.description });
  Todo.withId({this.id, this.name, this.todoTime, this.todoDate, this.colorTag, this.isFinalized, this.description});

  Color getColor(){
    if (colorTag == GREEN_COLOR){
      return Colors.green[700];
    }
    else if (colorTag == Todo.ORANGE_COLOR){
      return Colors.orange[600];
    }
    else if (colorTag == BLUE_COLOR){
      return Colors.blue[900];
    }
    return Colors.yellow;
  }

  Map<String,dynamic> toMap(){
    final map = Map<String,dynamic>();

    if (id != null){
      map['id'] = id;
    }
    map['name'] = name;
    map['todo_time'] = todoTime;
    map['todo_date'] = todoDate.toIso8601String();
    map['color_tag'] = colorTag;
    map['is_finalized'] = isFinalized;
    map['description'] = description;

    return map;
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo.withId(
      id: map['id'],
      name: map['name'],
      todoTime: map['todo_time'],
      todoDate: DateTime.parse(map['todo_date']),
      colorTag: map['color_tag'],
      isFinalized: map['is_finalized'],
      description: map['description']
    );
  }
}