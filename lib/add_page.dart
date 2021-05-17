import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist/database_helper.dart';
import 'package:todolist/todo.dart';

class AddPage extends StatefulWidget {
  final Function updateTodos;
  AddPage({this.updateTodos});

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {


  bool isNewTaskFinalized = false;
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  DateTime _todoDate = DateTime.now();
  int _colorTag = 1;
  String _todoTime = '';

  final DateFormat _dateFormatter = DateFormat('dd MMM yyyy');

  TextEditingController _dateController = TextEditingController();

  _handleDatePicker() async {
    final DateTime date = await showDatePicker(
        context: context,
        initialDate: _todoDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
    );

    if (date != null && date != _todoDate){
      setState(() {
        _todoDate = date;
      });
    }
    _dateController.text = _dateFormatter.format(_todoDate);
  }


  _submit() {
    if(_formKey.currentState.validate()) {
      _formKey.currentState.save();

      Todo newTodo = Todo(
        name: _name,
        description: _description,
        todoTime: _todoTime,
        todoDate: _todoDate,
        colorTag: _colorTag,
        isFinalized: (isNewTaskFinalized) ? 1 : 0,
      );
      
      DatabaseHelper.instance.insertTodo(newTodo);
      widget.updateTodos();

    }
    Navigator.pop(context);
  }

  @override
  void dispose(){
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            tooltip: 'Back',
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
              'New',
              style: Theme.of(context) //
                  .primaryTextTheme
                  .headline6
          ),
        ),
        body: SingleChildScrollView(
          child:
            GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget> [
                    Row(
                      children: <Widget> [
                        Checkbox(
                            value: isNewTaskFinalized,
                            activeColor: Colors.orange[400],
                            onChanged: (newValue){
                              setState(() {
                                isNewTaskFinalized = newValue;
                              });
                            }),
                        Text(
                            'Finalize',
                          style: TextStyle(
                            fontSize: 18.0
                          ),
                        ),
                      ],
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget> [
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Todo Name',
                              isDense: true,
                              contentPadding: EdgeInsets.all(4.0)
                            ),
                            validator: (input) => input.trim().isEmpty ? 'Please enter a todo title' : null,
                            onSaved: (input) => _name = input,
                            initialValue: _name,
                          ),
                          SizedBox(
                            height: 80.0,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      hintText: 'Date',
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(4.0)
                                  ),
                                  onTap: _handleDatePicker,
                                  controller: _dateController,
                                ),
                              ),
                              SizedBox(width: 10.0,),
                              Expanded(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: 'Time',
                                        isDense: true,
                                        contentPadding: EdgeInsets.all(4.0)
                                    ),
                                    validator: (input) => input.trim().isEmpty ? 'Please enter todo time' : null,
                                    onSaved: (input) => _todoTime = input,
                                    initialValue: _todoTime,
                                  ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 80.0,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                hintText: 'description',
                                isDense: true,
                                contentPadding: EdgeInsets.all(4.0)
                            ),
                            validator: (input) => input.trim().isEmpty ? 'Please enter todo description' : null,
                            onSaved: (input) => _description = input,
                            initialValue: _description,
                          ),
                        ]
                      )
                    )
                  ],
                ),
              ),
            )
        ),
    floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.orange[400],
      onPressed: () => _submit(),
      child: Icon(Icons.check)
    ),
    ),
    );
  }
}

