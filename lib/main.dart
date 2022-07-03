import 'package:flutter/material.dart';
import 'package:frontend_progetto_piattaforme/Layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MT Med',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Layout(title:"MT Med",),
    );
  }
}

