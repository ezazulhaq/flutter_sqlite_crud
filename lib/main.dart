import 'package:flutter/material.dart';
import 'package:sqlite_crud/constant.dart';
import 'package:sqlite_crud/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQLite CRUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
      ),
      home: MyHomePage(title: 'SQLite CRUD'),
    );
  }
}
