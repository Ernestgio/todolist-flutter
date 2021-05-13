import 'package:flutter/material.dart';
import 'package:todolist/others.dart';
import 'package:todolist/todo.dart';
import 'package:todolist/todo_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Todo> displayedTodos = [
    Todo(name:"Kerja",todoDate: "Today",todoTime: "10 AM", description: "Gitulah pokoknya", colorTag: Todo.BLUE_COLOR, isFinalized: false),
    Todo(name:"Kerja2",todoDate: "besok",todoTime: "9 AM", description: "Gitulah pokoknya(2)", colorTag: Todo.BLUE_COLOR, isFinalized: true)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              HomePageAppBar(),
              Container(
                padding: EdgeInsets.all(8.0),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: displayedTodos.length,
                  itemBuilder: (context,index){
                    return TodoCard(todo: displayedTodos[index]);
                  },
                ),
              ),
            ],
          )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: null,
          child: Icon(Icons.add)
        ),
    );
  }
}
