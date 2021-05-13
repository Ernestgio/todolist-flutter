import 'package:flutter/material.dart';
import 'package:todolist/todo.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;
  TodoCard({this.todo});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget> [
                    Row(
                      children: <Widget> [
                        Checkbox(value: todo.isFinalized, onChanged: null),
                        Text(
                          todo.name,
                          style: TextStyle(
                            fontSize: 18,
                            decoration: todo.isFinalized ? TextDecoration.lineThrough : null,
                          ),
                        )
                      ],
                    ),
                    Text(todo.description),
                    Text(
                      "${todo.todoDate}  ${todo.todoTime}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}
