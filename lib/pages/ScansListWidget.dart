import 'dart:io';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:one_context/one_context.dart';
import 'package:path/path.dart' as path;

import 'package:flutter/material.dart';
import 'package:file_icon/file_icon.dart';
import 'package:scanner/pages/HomePage.dart';
import 'package:scanner/pages/PdfViewerPage.dart';
import 'package:scanner/services/FileService.dart';
import 'package:scanner/services/Storage.dart';

class ListScans extends StatefulWidget {
  final String addPath;
  ListScans({@required this.addPath});
  @override
  ListScansState createState() => ListScansState();
}

class ListScansState extends State<ListScans> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: storageService.getLocalScannedDocs(widget.addPath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data != null) {
            return Padding(
              padding: EdgeInsets.all(4.0),
              child: AnimationLimiter(
                child: LiquidPullToRefresh(
                  showChildOpacityTransition: false,
                  animSpeedFactor: 5.0,
                  onRefresh: () {
                    setState(() {});
                    return Future.value(false);
                  },
                  child: snapshot.data.length != 0
                      ? ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: Duration(milliseconds: 400),
                              child: SlideAnimation(
                                child: FadeInAnimation(
                                  child: GestureDetector(
                                    onTap: () =>
                                        _openFileOrDir(snapshot, index),
                                    child: Card(
                                      child: Slidable(
                                        actionPane: SlidableDrawerActionPane(),
                                        actionExtentRatio: 0.25,
                                        actions: (snapshot.data[index] is File)
                                            ? [
                                                IconSlideAction(
                                                  caption: 'Share',
                                                  color: Colors.indigo,
                                                  icon: Icons.share,
                                                  onTap: () =>
                                                      fileService.shareFile(
                                                          snapshot, index),
                                                ),
                                              ]
                                            : null,
                                        secondaryActions: [
                                          IconSlideAction(
                                            caption: 'Delete',
                                            color: Colors.red,
                                            icon: Icons.delete,
                                            onTap: () => fileService
                                                .showDeleteDialog()
                                                .then((delete) {
                                              if (delete) {
                                                fileService
                                                    .deleteFile(snapshot, index)
                                                    .then((value) {
                                                  if (value) setState(() {});
                                                });
                                              }
                                            }),
                                          ),
                                        ],
                                        child: ListTile(
                                          leading: FileIcon(
                                            path.basename(
                                                snapshot.data[index].path),
                                            size: 35,
                                          ),
                                          title: Text(path.basename(
                                              snapshot.data[index].path)),
                                          trailing:
                                              _getEntitySize(snapshot, index),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : Text("No PDFs found."),
                ),
              ),
            );
          } else
            return Center(child: CircularProgressIndicator());
        } else
          return Center(child: CircularProgressIndicator());
      },
    );
  }
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
      : Icon(Icons.chevron_right);
}

_openFileOrDir(AsyncSnapshot<dynamic> snapshot, int index) {
  if (snapshot.data[index] is File) {
    print("Opening Pdf.");
    return OneContext.instance.push(MaterialPageRoute(
        builder: (context) => PdfViewer(pdfPath: snapshot.data[index].path)));
  } else {
    print("Opening Dir.");
    return OneContext.instance.push(MaterialPageRoute(
        builder: (context) => HomePage(
              addPath: path.basename(snapshot.data[index].path).toString(),
              appBarTitle: path.basename(snapshot.data[index].path).toString(),
            )));
  }
}
