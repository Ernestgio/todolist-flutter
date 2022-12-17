import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist/api/local_auth.dart';
import 'package:todolist/database_helper.dart';
import 'package:todolist/todo.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:local_auth/local_auth.dart';

import 'dart:async';
import 'package:flutter/services.dart';


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

  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  final DateFormat _dateFormatter = DateFormat('dd MMM yyyy');
  final DateFormat _timeFormatter = DateFormat('hh:mm a');

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

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

  _selectTime() async {
    DateTime chosen = await DatePicker.showTime12hPicker(context,
        showTitleActions: true,
        currentTime: DateTime.now(), locale: LocaleType.en);
    if(chosen != null) setState(() => _todoTime = _timeFormatter.format(chosen));
    _timeController.text = (_todoTime);
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
      widget.updateTodos(false);
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
            onPressed: () {
              widget.updateTodos(false);
              Navigator.pop(context);
            }
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
                        SizedBox(width: 80.0,),
                        DropdownButton(
                            value: _colorTag,
                            onChanged: (value){
                              setState(() {
                                _colorTag = value;
                              });
                            },
                            items: [
                              DropdownMenuItem(
                                  child: Container(
                                    width: 100.0,
                                    height: 10.0,
                                    color: Colors.green[700],
                                  ),
                                  value: Todo.GREEN_COLOR,
                              ),
                              DropdownMenuItem(
                                child: Container(
                                  width: 100.0,
                                  height: 10.0,
                                  color: Colors.orange[600],
                                ),
                                value: Todo.ORANGE_COLOR,
                              ),
                              DropdownMenuItem(
                                child: Container(
                                  width: 100.0,
                                  height: 10.0,
                                  color: Colors.blue[900],
                                ),
                                value: Todo.BLUE_COLOR,
                              ),
                              DropdownMenuItem(
                                child: Container(
                                  width: 100.0,
                                  height: 10.0,
                                  color: Colors.yellow,
                                ),
                                value: Todo.YELLOW_COLOR,
                              )
                            ],
                        )
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
                                    onTap: _selectTime,
                                    controller: _timeController,
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
        onPressed: () async {
          final isAuthenticated = await BiomAuthentication.authenticate();
          if (isAuthenticated){
            _submit();
          }
        },
        child: Icon(Icons.check)
    ),
    ),
    );
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
