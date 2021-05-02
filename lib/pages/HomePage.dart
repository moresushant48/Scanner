import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scanner/appbar/MainAppBar.dart';
import 'package:scanner/pages/ScanPage.dart';
import 'package:scanner/pages/ScansListWidget.dart';
import 'package:scanner/services/Storage.dart';

class HomePage extends StatefulWidget {
  final String addPath;
  final String appBarTitle;
  HomePage({this.addPath, this.appBarTitle});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<FileSystemEntity> files = [];

  @override
  void initState() {
    super.initState();
    storageService.createHomeDir();
  }

  @override
  Widget build(BuildContext context) {
    print("Init path : " + widget.addPath.toString());
    return Scaffold(
      appBar: mainAppBar(context, widget.appBarTitle, setState),
      body: Center(
        child: ListScans(
          addPath: widget.addPath,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.camera_alt_outlined,
        ),
        onPressed: () async {
          print("addPath in HomePage : " + widget.addPath.toString());
          scanDocument(context, widget.addPath).then((value) {
            setState(() {});
          });
        },
      ),
    );
  }
}
