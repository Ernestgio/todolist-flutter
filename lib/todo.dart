import 'package:flutter/material.dart';

class Todo {
  String name;
  String description;
  int colorTag;
  bool isFinalized;
  String todoDate;
  String todoTime;

  static const int GREEN_COLOR = 1;
  static const int ORANGE_COLOR = 2;
  static const int BLUE_COLOR = 3;
  static const int YELLOW_COLOR = 4;

  Todo({this.name, this.todoDate, this.todoTime, this.colorTag, this.isFinalized, this.description });

  Color getColor(){
    if (colorTag == GREEN_COLOR){
      return Colors.green[700];
    }
    else if (colorTag == ORANGE_COLOR){
      return Colors.orange[600];
    }
    else if (colorTag == BLUE_COLOR){
      return Colors.blueAccent[900];
    }
    else{
      return Colors.yellow;
    }
  }

}