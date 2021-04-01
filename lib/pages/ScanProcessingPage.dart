import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:pdf/pdf.dart';
import 'package:image/image.dart' as i;
import 'package:pdf/widgets.dart' as pw;

class ScanProcessing extends StatefulWidget {
  final List<XFile> images;
  final List<String> paths;

  const ScanProcessing({Key key, @required this.images, @required this.paths})
      : super(key: key);
  @override
  _ScanProcessingState createState() => _ScanProcessingState();
}

class _ScanProcessingState extends State<ScanProcessing> {
  List<XFile> images;
  List<String> paths;

  @override
  void initState() {
    super.initState();
    this.images = widget.images;
    this.paths = widget.paths;
  }

  _cropImage(int currIndex) {
    print(currIndex);
    ImageCropper.cropImage(sourcePath: widget.paths[currIndex])
        .then((actualFile) {
      setState(() {
        if (actualFile != null) images[currIndex] = XFile(actualFile.path);
      });
    });
  }

  _saveDoc() async {
    final pdf = pw.Document();

    images.forEach((image) {
      i.Image img = i.decodeImage(File(image.path).readAsBytesSync());
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.zero,
          build: (context) {
            return pw.Center(
              child: pw.Image(
                pw.RawImage(
                  width: img.width,
                  height: img.height,
                  bytes: img.getBytes(),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    List<XFile> images = widget.images;
    return Scaffold(
      appBar: AppBar(
        title: Text("Modify"),
        actions: [
          //
          TextButton(
            child: Text(
              "Save",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => _saveDoc(),
          )
          //
        ],
      ),
      body: GridView.builder(
        itemCount: images.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          return images.isNotEmpty
              ? GestureDetector(
                  onTap: () => _cropImage(index),
                  child: Card(
                    child: Image.file(File(images[index].path)),
                  ),
                )
              : CircularProgressIndicator();
        },
      ),
    );
  }
}
