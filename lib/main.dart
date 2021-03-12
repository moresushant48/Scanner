import 'package:flutter/material.dart';

void main() {
  runApp(Index());
}

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: Text("Home"),
        ),
      ),
    );
  }
}
