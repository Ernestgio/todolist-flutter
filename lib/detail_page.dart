import 'package:flutter/material.dart';

import 'package:todolist/others.dart';

class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  bool isNewTaskFinalized = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            DetailPageAppBar(),
            Column(
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
                )
              ],
            )
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange[400],
          onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          child: Icon(Icons.check)
      ),
    );
  }
}

