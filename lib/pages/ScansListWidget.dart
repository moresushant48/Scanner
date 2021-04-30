import 'dart:io';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:one_context/one_context.dart';
import 'package:path/path.dart' as path;

import 'package:flutter/material.dart';
import 'package:file_icon/file_icon.dart';
import 'package:scanner/pages/PdfViewerPage.dart';
import 'package:scanner/services/FileService.dart';
import 'package:scanner/services/Storage.dart';

Widget scanList(BuildContext context) {
  return StatefulBuilder(
    builder: (BuildContext context, setState) {
      return FutureBuilder(
        future: storageService.getLocalScannedDocs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data != null) {
              return Padding(
                padding: EdgeInsets.all(4.0),
                child: AnimationLimiter(
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: Duration(milliseconds: 400),
                        child: SlideAnimation(
                          child: FadeInAnimation(
                            child: GestureDetector(
                              onTap: () {
                                print("Opening pdf");
                                OneContext.instance
                                    .push(MaterialPageRoute(
                                  builder: (context) => PdfViewer(
                                      pdfPath: snapshot.data[index].path),
                                ))
                                    .then((value) {
                                  setState(() {});
                                });
                              },
                              child: Card(
                                child: ListTile(
                                  leading: FileIcon(
                                    path.basename(snapshot.data[index].path),
                                    size: 35,
                                  ),
                                  title: Text(
                                      path.basename(snapshot.data[index].path)),
                                  trailing: _getEntitySize(snapshot, index),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            } else
              return Center(child: CircularProgressIndicator());
          } else
            return Center(child: CircularProgressIndicator());
        },
      );
    },
  );
}

Widget _getEntitySize(AsyncSnapshot<dynamic> snapshot, int index) {
  return (snapshot.data[index] is File)
      ? FutureBuilder(
          future: File(snapshot.data[index].path).length(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.done) {
              return Text(fileService.formatBytes(snap.data, 0));
            } else
              return CircularProgressIndicator();
          })
      : null;
}
