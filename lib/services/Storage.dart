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
    return "${(await getExternalStorageDirectory()).path}/BrainyVision/";
  }

  Future<String> getSavePathForImage(String fileName) async {
    return "${(await getExternalStorageDirectory()).path}/Pictures/$fileName.jpg";
  }

  Future<void> createHomeDir() async {
    Directory dir =
        Directory((await getExternalStorageDirectory()).path + "/BrainyVision");
    if (await dir.exists()) {
      print("HOME DIR EXISTS");
    } else {
      dir.create().then((dir) => print("HOME DIR " + dir.path + " CREATED."));
    }
  }

  Future<String> getSavePathForPdf(String addPath, String fileName) async {
    // print("addPath in StorageService : " + addPath);
    if (addPath == null) {
      print("NULL HAI RE : " + addPath.toString());
    } else
      print("NULL NHI HAI");
    return addPath != null
        ? "${(await getHomePath())}$addPath/$fileName.pdf"
        : "${(await getHomePath())}$fileName.pdf";
  }

  Future<File> getFileFromImages(
      List<XFile> images, String fileName, String addPath) async {
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
    String filePath = await getSavePathForPdf(addPath, fileName);
    print("=============\nFILE PATH " + filePath);
    final file = File(filePath);
    Uint8List data = await pdf.save();
    file.writeAsBytes(data);

    return file;
  }

  void saveOnDevice(List<XFile> images, String fileName, String addPath) async {
    // print("Save Path : " + addPath + "//" + fileName);
    getFileFromImages(images, fileName, addPath).then((file) {
      print("Saved file At : " + file.path);
    });
  }

  Future<List<FileSystemEntity>> getLocalScannedDocs(String addPath) async {
    print("Inside Local Scanned docs.");
    String homePath = await getHomePath() + (addPath != null ? addPath : "");
    print("Home Path : " + homePath);
    Directory homeDir = Directory(homePath);
    print("Home Dir : " + homeDir.path);
    // setState(() {});
    return await homeDir.list().toList();
  }
}

final storageService = StorageService();
