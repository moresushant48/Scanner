import 'dart:io';

import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:scanner/appbar/MainAppBar.dart';
import 'package:scanner/pages/ScanPage.dart';
import 'package:scanner/pages/ScansListWidget.dart';
import 'package:scanner/services/Storage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<FileSystemEntity> files = [];

  @override
  void initState() {
    super.initState();
    print("Init State.");
    // getLocalScannedDocs();
  }

  Future<List<FileSystemEntity>> getLocalScannedDocs() async {
    print("Inside Local Scanned docs.");
    String homePath = await storageService.getHomePath();
    print("Home Path : " + homePath);
    Directory homeDir = Directory(homePath);
    print("Home Dir : " + homeDir.path);
    // setState(() {});
    return await homeDir.list().toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(context),
      body: Center(
        child: LiquidPullToRefresh(
          showChildOpacityTransition: false,
          onRefresh: () {
            setState(() {});
            return Future.value(false);
          },
          child: FutureBuilder(
            future: getLocalScannedDocs(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data != null) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: scanList(context, snapshot.data),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              } else
                return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.login),
        onPressed: () async {
          scanDocument(context).then((value) {
            setState(() {});
          });
        },
      ),
    );
  }
}
