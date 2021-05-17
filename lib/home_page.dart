import 'package:flutter/material.dart';
import 'package:todolist/others.dart';
import 'package:todolist/todo.dart';
import 'package:todolist/todo_card.dart';
import 'package:todolist/database_helper.dart';

import 'add_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<List<Todo>> _displayedTodos;

  @override
  void initState(){
    super.initState();
    _updateTodoList();
  }

  _updateTodoList() {
    setState(() {
      _displayedTodos = DatabaseHelper.instance.getTodoList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Things To Do'),
      ),
        body: SafeArea(
          child: FutureBuilder<List<Todo>>(
            future: _displayedTodos,
            builder: (context,snapshot) {
              if (!snapshot.hasData){
                return Center(
                  child: Text('No Data'),
                );
              }
            return Container(
              padding: EdgeInsets.all(8.0),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context,index){
                  return TodoCard(todo: snapshot.data[index],updateTodos: _updateTodoList,);
                },
              ),
            );}
          )
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange[400],
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_) => AddPage(updateTodos: _updateTodoList)));
          },
          child: Icon(Icons.add),
        ),
    );
  }
}
