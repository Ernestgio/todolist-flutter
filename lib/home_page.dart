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
  bool isDoneFilterOn;

  Widget appBarTitle;
  IconData appBarSearchIcon;

  @override
  void initState(){
    super.initState();
    _updateTodoList(false);
    appBarSearchIcon = Icons.search;
    appBarTitle = Text('Things to do');
    isDoneFilterOn = false;
  }

  _updateTodoList(statusFilter) {
    if(statusFilter){
      setState(() {
        _displayedTodos = DatabaseHelper.instance.getDoneTodoList();
      });
    }
    else{
      setState(() {
        _displayedTodos = DatabaseHelper.instance.getTodoList();
      });
    }
  }

  _searchTodoList(queryString){
    setState(() {
      _displayedTodos = DatabaseHelper.instance.searchTodoList(queryString);
      appBarSearchIcon = Icons.search;
      appBarTitle = Text('Things to do');
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        actions: [
          IconButton(
              icon: Icon(
                appBarSearchIcon,
                color: Colors.white,
              ),
              tooltip: 'Search',
              onPressed: (){
                if (appBarSearchIcon == Icons.search) {
                  setState(() {
                    appBarSearchIcon = Icons.close;
                    appBarTitle = TextField(
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: "Search todos",
                          isDense: true,
                          contentPadding: EdgeInsets.all(4.0),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      onSubmitted: (searchKey){
                        _searchTodoList(searchKey);
                      },
                    );
                  });
                }
                else{
                  setState(() {
                    appBarSearchIcon = Icons.search;
                    appBarTitle = Text('Things to do');
                  });
                }

              },
          ),
          PopupMenuButton(
            icon: Icon(
              IconData(
                  0xe9fe,
                  fontFamily: 'MaterialIcons',
                  matchTextDirection: true
              ),
              color: Colors.white,

            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(
                  children: [
                    Expanded(child: Text('Status')),
                    Checkbox(value: isDoneFilterOn, onChanged: (newValue){
                      setState(() {
                        isDoneFilterOn = newValue;
                      });
                      _updateTodoList(isDoneFilterOn);
                    })
                  ],
                ),
              ),
              PopupMenuItem(
                child: Text('Date'),
              ),
              PopupMenuItem(
                child: Text('Priority'),
              ),
            ],
          )
        ],
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
