import 'package:flutter/material.dart';
import 'package:scanner/appbar/MainAppBar.dart';

import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as signIn;
import 'package:scanner/services/Auth.dart';

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
      body: Container(
        child: Text(
          "Home",
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.login),
        onPressed: () async {
          print("clicked in");
          try {
            authService.signOut();
          } catch (error) {
            print(error);
          }
        },
      ),
    );
  }
}
