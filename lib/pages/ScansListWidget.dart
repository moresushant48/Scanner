import 'dart:io';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:one_context/one_context.dart';
import 'package:path/path.dart' as path;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scanner/pages/PdfViewerPage.dart';

Widget scanList(BuildContext context, List<FileSystemEntity> files) {
  return AnimationLimiter(
    child: ListView.builder(
      itemCount: files.length,
      itemBuilder: (context, index) {
        return AnimationConfiguration.staggeredList(
          position: index,
          duration: Duration(milliseconds: 400),
          child: SlideAnimation(
            child: FadeInAnimation(
              child: GestureDetector(
                onTap: () {
                  print("Opening pdf");
                  // pdfView(files[index].path);
                  OneContext.instance.push(MaterialPageRoute(
                    builder: (context) => PdfViewer(pdfPath: files[index].path),
                  ));
                },
                onTapCancel: () {
                  print("Canceled.");
                },
                child: Card(
                  child: ListTile(
                    leading: Icon(
                      FontAwesomeIcons.solidFilePdf,
                      size: 35.0,
                      color: Colors.redAccent,
                    ),
                    title: Text(path.basename(files[index].path)),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}
