import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:image/image.dart' as i;
import 'package:pdf/widgets.dart' as pw;

class StorageService {
  StorageService();

  Future<String> getHomePath() async {
    return "${(await getApplicationDocumentsDirectory()).path}/BrainyVision/";
  }

  Future<String> getSavePathForImage(String fileName) async {
    return "${(await getExternalStorageDirectory()).path}/Pictures/$fileName.jpg";
  }

  Future<String> getSavePathForPdf(String fileName) async {
    return "${(await getExternalStorageDirectory()).path}/$fileName.pdf";
  }

  Future<File> getFileFromImages(List<XFile> images, String fileName) async {
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

    final file = File(await getSavePathForPdf(fileName));
    Uint8List data = await pdf.save();
    file.writeAsBytes(data);

    return file;
  }

  void saveOnDevice(List<XFile> images, String fileName) async {
    getFileFromImages(images, fileName).then((file) {
      print("Saved file At : " + file.path);
    });
  }
}

final storageService = StorageService();
