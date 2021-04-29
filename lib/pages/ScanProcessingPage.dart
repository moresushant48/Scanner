import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:one_context/one_context.dart';
import 'package:scanner/services/FileService.dart';
import 'package:scanner/services/Storage.dart';

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

  bool _pressedSave = false;

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
    print("Inside savedoc.");
    fileService.getFileName("").then((fileName) async {
      if (fileName != null) {
        print("FILENAME : " + fileName);
        print("Returned");

        storageService.saveOnDevice(images, fileName);
        // driveStorage.saveOnGoogleDrive(images, fileName);

        setState(() {
          _pressedSave = false;
          OneContext.instance.popUntil((route) => route.isFirst ? true : false);
        });
      } else {
        setState(() {
          _pressedSave = false;
        });
      }
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
          Visibility(
            visible: _pressedSave,
            child: Center(
              child: Container(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            replacement: TextButton(
              child: Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                setState(() {
                  _pressedSave = true;
                });
                _saveDoc();
              },
            ),
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
