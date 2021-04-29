import 'dart:io';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:one_context/one_context.dart';
import 'package:path/path.dart' as path;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scanner/pages/PdfViewerPage.dart';
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
                                  leading: Icon(
                                    FontAwesomeIcons.solidFilePdf,
                                    size: 35.0,
                                    color: Colors.redAccent,
                                  ),
                                  title: Text(
                                      path.basename(snapshot.data[index].path)),
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
