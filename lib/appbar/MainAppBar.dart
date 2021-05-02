import 'dart:io';

import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';
import 'package:scanner/services/FileService.dart';
import 'package:scanner/services/Storage.dart';

AppBar mainAppBar(BuildContext context, String appBarTitle, setState) {
  List<String> choices = [];
  choices.add("Settings");
  return AppBar(
    leading: appBarTitle == null ? _addFolder(appBarTitle, setState) : null,
    title: Text(appBarTitle != null ? appBarTitle : "Brainy Vision"),
    centerTitle: true,
    elevation: 0.0,
    actions: [
      PopupMenuButton<String>(
        onSelected: (value) {
          OneContext.instance.pushNamed(value);
        },
        itemBuilder: (context) {
          return choices.map((String choice) {
            print("Path : /" + choice);
            return PopupMenuItem<String>(
              child: Text(choice),
              value: "/" + choice,
            );
          }).toList();
        },
      )
    ],
  );
}

Widget _addFolder(String appBarTitle, setState) {
  return IconButton(
    icon: Icon(Icons.create_new_folder_sharp),
    onPressed: () {
      print("pressed");
      fileService.getFolderName("").then((folderName) async {
        //
        Directory dir =
            Directory(await storageService.getHomePath() + folderName);

        dir.create().then((createdDir) {
          print("Dir created.");
          setState(() {});
        });
      });
    },
  );
}
