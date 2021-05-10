import 'dart:io';

import 'package:one_context/one_context.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter_fullpdfview/flutter_fullpdfview.dart' as fullPdf;
import 'package:scanner/services/FileService.dart';

class PdfViewer extends StatefulWidget {
  final String pdfPath;
  PdfViewer({Key key, @required this.pdfPath}) : super(key: key);

  @override
  _PdfViewerState createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  editPdfName(String pdfPath) {
    fileService
        .getFileName(path.basenameWithoutExtension(pdfPath))
        .then((fileName) {
      if (fileName != null) {
        if (fileName != path.basenameWithoutExtension(widget.pdfPath)) {
          File file = File(pdfPath);
          file.rename(path.join(
              path.dirname(pdfPath), (fileName + FileService.EXTENSION_PDF)));
          OneContext.instance.pop();
        } else
          return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(path.basename(widget.pdfPath)),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => editPdfName(widget.pdfPath),
            )
          ],
        ),
        body: fullPdf.PDFView(
          filePath: widget.pdfPath,
        ));
  }
}
