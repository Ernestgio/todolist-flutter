import 'package:flutter/material.dart';
import 'package:todolist/database_helper.dart';
import 'package:todolist/todo.dart';
import 'package:intl/intl.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;
  final Function updateTodos;
  TodoCard({this.todo, this.updateTodos});
  final DateFormat _dateFormatter = DateFormat('dd MMM yyyy');

  @override
  Widget build(BuildContext context) {
    return Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget> [
                      Row(
                        children: <Widget> [
                          Checkbox(
                              value: todo.isFinalized == 1,
                              onChanged: (value) {
                                todo.isFinalized = value ? 1 : 0;
                                DatabaseHelper.instance.updateTodo(todo);
                                updateTodos(false);
                              },
                              activeColor: Colors.orange[400],
                          ),
                          Text(
                            todo.name,
                            style: TextStyle(
                              fontSize: 18,
                              decoration: todo.isFinalized == 1 ? TextDecoration.lineThrough : null,
                            ),
                          )
                        ],
                      ),
                      Text(todo.description),
                      Text(
                        "${_dateFormatter.format((todo.todoDate))}  ${todo.todoTime}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              Container(
                width: 8.0,
                color: todo.getColor(),
              ),
              ],
            ),
          ),
        )
    );
  }
}
