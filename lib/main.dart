import 'package:flutter/material.dart';
import 'package:todolist/home_page.dart';
import 'package:todolist/detail_page.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => HomePage(),
      'detail': (context) => DetailPage(),
    }
  ));
}




