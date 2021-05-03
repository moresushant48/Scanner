import 'dart:math';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_context/one_context.dart';
import 'package:share/share.dart';

class FileService {
  static final String EXTENSION_PDF = ".pdf";

  TextEditingController fileNameController = TextEditingController();
  TextEditingController folderNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _folderFormKey = GlobalKey<FormState>();

  Future<String> getFileName(String defName) async {
    fileNameController.text = defName;
    return OneContext().showDialog(
      builder: (ctx) => AlertDialog(
        title: Text(
          "Rename",
          textAlign: TextAlign.center,
        ),
        content: Form(
          key: _formKey,
          child: TextFormField(
            validator: (value) {
              return value.isEmpty ? "File Name cannot be Blank." : null;
            },
            controller: fileNameController,
            keyboardType: TextInputType.name,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9_-]')),
            ],
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: Colors.blue)),
              labelText: 'Enter File Name',
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: Text("Cancel")),
          TextButton(
              onPressed: () {
                // if (fileNameController.value.text != "" &&
                //     fileNameController.value.text != null) {
                final FormState form = _formKey.currentState;
                if (form.validate()) {
                  print('Form is valid');
                  Navigator.pop(ctx, fileNameController.value.text);
                } else {
                  print('Form is invalid');
                }
                // } else {}
              },
              child: Text("Save")),
        ],
      ),
    );
  }

  Future<String> getFolderName(String defName) async {
    folderNameController.text = defName;
    return OneContext().showDialog(
      builder: (ctx) => AlertDialog(
        title: Text(
          "Add Folder",
          textAlign: TextAlign.center,
        ),
        content: Form(
          key: _folderFormKey,
          child: TextFormField(
            validator: (value) {
              return value.isEmpty ? "Folder Name cannot be Blank." : null;
            },
            controller: folderNameController,
            keyboardType: TextInputType.name,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),
            ],
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: Colors.blue)),
              labelText: 'Enter Folder Name',
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: Text("Cancel")),
          TextButton(
              onPressed: () {
                final FormState form = _folderFormKey.currentState;
                if (form.validate()) {
                  print('Form is valid');
                  Navigator.pop(ctx, folderNameController.value.text);
                } else {
                  print('Form is invalid');
                }
              },
              child: Text("Save")),
        ],
      ),
    );
  }

  String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }

  Future<bool> deleteFile(AsyncSnapshot<dynamic> snapshot, int index) {
    if (snapshot.data[index] is File) {
      File file = File(snapshot.data[index].path);
      return file.delete().then((value) => Future.value(true));
    } else {
      Directory dir = Directory(snapshot.data[index].path);
      return dir.delete().then((value) => Future.value(true));
    }
    return Future.value(false);
  }

  shareFile(AsyncSnapshot<dynamic> snapshot, int index) {
    Share.shareFiles([snapshot.data[index].path],
        subject:
            "Checkout this PDF : " + path.basename(snapshot.data[index].path));
  }
}

final fileService = FileService();
