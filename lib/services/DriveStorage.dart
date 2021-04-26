import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:one_context/one_context.dart';
import 'package:scanner/services/Auth.dart';
import 'package:scanner/services/GoogleAuthClient.dart';
import 'package:scanner/services/Prefs.dart';
import 'package:scanner/services/Storage.dart';

class DriveStorage {
  drive.DriveApi d;
  final String rootFolderName = "BrainyVision";
  String rootFolderId;

  DriveStorage() {
    authService.getCurrentUser().then((googleSignInAccount) async {
      var client = GoogleAuthClient(await googleSignInAccount.authHeaders);
      d = drive.DriveApi(client);
    });
  }

  void saveOnGoogleDrive(List<XFile> images, String fileName) {
    storageService.getFileFromImages(images, fileName).then((file) async {
      // driveStorage.getRootFolderId().then((rootFolderId) {
      // });
      driveStorage
          .uploadFileToFolder(rootFolderId, fileName, file)
          .then((value) {
        print("ID : " + value);
        OneContext.instance.showSnackBar(
          builder: (ctx) => SnackBar(content: Text("File Uploaded." + value)),
        );
      });
    });
  }

  Future<String> getRootFolderId() async {
    String folderId =
        await prefService.getSharedString(PrefService.ROOT_FOLDER_ID);
    if (folderId != "null") {
      print("IsNotEmpty ID : " + folderId);
      rootFolderId = folderId;
    } else {
      createFolderOnDrive(rootFolderName).then((folderId) {
        prefService.putSharedString(PrefService.ROOT_FOLDER_ID, folderId);
      });
    }
    return folderId;
  }

  Future<String> createFolderOnDrive(String folderName) async {
    if (d != null) {
      drive.File fileMetadata = new drive.File();
      fileMetadata.name = folderName;
      fileMetadata.mimeType = "application/vnd.google-apps.folder";
      drive.File createdFolder = await d.files.create(fileMetadata);
      return createdFolder.id;
    } else
      return "null";
  }

  Future<String> uploadFileToFolder(
      String rootFolderId, String fileName, File createdFile) async {
    // if (d != null) {
    authService.getCurrentUser().then((googleSignInAccount) async {
      var client = GoogleAuthClient(await googleSignInAccount.authHeaders);
      d = drive.DriveApi(client);
      print("Folder : " +
          rootFolderId.toString() +
          "\nFileName : " +
          fileName.toString());
      drive.File fileToUpload = drive.File();
      // fileToUpload.parents = [rootFolderId];
      fileToUpload.name = fileName;
      var response = await d.files.create(
        fileToUpload,
        uploadMedia:
            drive.Media(createdFile.openRead(), createdFile.lengthSync()),
      );
      return response.id;
    });
    return "";
    // } else
    // return "null";
  }
}

final driveStorage = DriveStorage();
