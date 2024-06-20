// main.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_3/teams_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Football Teams',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false, // Esta línea elimina el banner de debug
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isGridView = true;

  void _toggleTheme() {
    // Toggle theme logic
  }

  void _toggleView() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TeamsView(
      toggleTheme: _toggleTheme,
      toggleView: _toggleView,
      isGridView: _isGridView,
    );
  }
}
