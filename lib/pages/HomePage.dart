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
          child: scanList(context),
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
