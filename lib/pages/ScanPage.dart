import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:scanner/pages/ScanProcessingPage.dart';
import 'package:scanner/services/Storage.dart';

Future<File> scanDocument(BuildContext context) async {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ScanPage(),
    ),
  );
}

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  CameraController _cameraController;

  List<XFile> capturedImages = [];
  List<String> capturedPath = [];

  bool scanMore = true;

  @override
  void initState() {
    print("Before INIT");
    initScan();
    print("After INIT");
    super.initState();
  }

  initScan() async {
    availableCameras().then((cameras) {
      _cameraController =
          CameraController(cameras[0], ResolutionPreset.ultraHigh);
      _cameraController.initialize().then((value) {
        _cameraController.setFlashMode(FlashMode.off);
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;

    if (_cameraController == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Stack(
        children: [
          AspectRatio(
            aspectRatio: deviceRatio,
            child: Container(child: CameraPreview(_cameraController)),
          ),
          Align(
            alignment: Alignment(0, 1),
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    if (capturedImages.length > 0)
                      Stack(
                        children: [
                          Container(
                              height: 50,
                              width: 50,
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  )),
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: Image(
                                  image:
                                      FileImage(File(capturedImages.last.path)),
                                ),
                              )),
                          FractionalTranslation(
                            translation: Offset(-.2, -.2),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(6),
                              child: Text(
                                capturedImages.length.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    Spacer(),
                    GestureDetector(
                      onTap: () async {
                        try {
                          if (_cameraController.value.isTakingPicture) {
                            // A capture is already pending, do nothing.
                            return null;
                          }
                          final XFile xfile =
                              await _cameraController.takePicture();
                          await ImageCropper.cropImage(sourcePath: xfile.path)
                              .then((file) async {
                            storageService
                                .getSavePathForImage(DateTime.now().toString())
                                .then((tempPath) {
                              FlutterImageCompress.compressAndGetFile(
                                      file.path, tempPath,
                                      quality: 50)
                                  .then((compressedFile) {
                                setState(() {
                                  capturedImages
                                      .add(XFile(compressedFile.path));
                                  capturedPath.add(compressedFile.path);
                                });
                              });
                            });
                          });
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                          height: 50,
                          width: 50,
                        ),
                      ),
                    ),
                    Spacer(),
                    if (capturedImages.length > 0)
                      GestureDetector(
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              )),
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Icon(
                              Icons.chevron_right_sharp,
                              color: Colors.white,
                              size: 40.0,
                            ),
                          ),
                        ),
                        onTap: () async {
                          File pdf = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ScanProcessing(
                                images: capturedImages,
                                paths: capturedPath,
                              ),
                            ),
                          );
                          if (pdf != null) Navigator.pop(context, pdf);
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}
