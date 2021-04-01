import 'package:flutter/material.dart';
import 'package:scanner/appbar/MainAppBar.dart';
import 'package:scanner/pages/ScanPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(context),
      body: Center(
        child: Text("Ongoing."),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.login),
        onPressed: () async {
          scanDocument(context);
        },
      ),
    );
  }
}
