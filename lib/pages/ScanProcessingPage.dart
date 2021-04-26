import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:one_context/one_context.dart';
import 'package:scanner/services/Auth.dart';
import 'package:scanner/services/DriveStorage.dart';
import 'package:scanner/services/GoogleAuthClient.dart';
import 'package:scanner/services/Prefs.dart';
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

  TextEditingController fileNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
    getFileName().then((fileName) async {
      if (fileName != null) {
        print("FILENAME : " + fileName);
        print("Returned");

        storageService.saveOnDevice(images, fileName);
        // driveStorage.saveOnGoogleDrive(images, fileName);

        setState(() {
          _pressedSave = false;
        });
      } else {
        setState(() {
          _pressedSave = false;
        });
      }
    });
  }

  Future<String> getFileName() async {
    return OneContext().showDialog(
      builder: (ctx) => AlertDialog(
        title: Text(
          "Rename",
          textAlign: TextAlign.center,
        ),
        content: Form(
          key: _formKey,
          child: TextFormField(
            validator: (value) {
              return value.isEmpty ? "File Name cannot be Blank." : null;
            },
            controller: fileNameController,
            keyboardType: TextInputType.name,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9_-]')),
            ],
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: Colors.blue)),
              labelText: 'Enter File Name',
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: Text("Cancel")),
          TextButton(
              onPressed: () {
                // if (fileNameController.value.text != "" &&
                //     fileNameController.value.text != null) {
                final FormState form = _formKey.currentState;
                if (form.validate()) {
                  print('Form is valid');
                  Navigator.pop(ctx, fileNameController.value.text);
                } else {
                  print('Form is invalid');
                }
                // } else {}
              },
              child: Text("Save")),
        ],
      ),
    );
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
