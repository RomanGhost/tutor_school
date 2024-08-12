import 'package:flutter/material.dart';

import 'screens/main_page/main_page.dart';


void main() {
  runApp(MyApp());
}

/// Основное приложение
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Репетитор английского языка',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
