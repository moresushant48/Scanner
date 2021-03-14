import 'package:flutter/material.dart';
import 'package:scanner/appbar/MainAppBar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(context),
      body: Container(
        child: Text(
          "Home",
        ),
      ),
    );
  }
}
