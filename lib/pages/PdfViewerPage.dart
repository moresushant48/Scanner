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
    return fullPdf.PDFView(
      filePath: widget.pdfPath,
    );
  }
}
