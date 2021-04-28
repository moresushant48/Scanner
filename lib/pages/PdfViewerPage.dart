import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter_fullpdfview/flutter_fullpdfview.dart' as fullPdf;

class PdfViewer extends StatefulWidget {
  final String pdfPath;
  PdfViewer({Key key, @required this.pdfPath}) : super(key: key);

  @override
  _PdfViewerState createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(path.basename(widget.pdfPath)),
        ),
        body: fullPdf.PDFView(
          filePath: widget.pdfPath,
        ));
  }
}
