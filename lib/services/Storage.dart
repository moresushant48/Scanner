import 'package:path_provider/path_provider.dart';

class StorageService {
  StorageService();

  Future<String> getHomePath() async {
    return "${(await getApplicationDocumentsDirectory()).path}/BrainyVision/";
  }

  Future<String> getSavePathFor(String fileName) async {
    return "${(await getApplicationDocumentsDirectory()).path}/$fileName";
  }
}

final storageService = StorageService();
