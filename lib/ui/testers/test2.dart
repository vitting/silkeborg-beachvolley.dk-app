import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:silkeborgbeachvolley/ui/test.dart';
import 'package:uuid/uuid.dart';



class Test2 {
  static FirebaseStorage _firestorage;

  static FirebaseStorage get firestorageInstance {
    if (_firestorage == null) {
      _firestorage = FirebaseStorage.instance;
    }

    return _firestorage;
  }

  static Future<File> processNewsImage(File imageFile) async {
    Image imageDecoded = decodeImage(await imageFile.readAsBytes());
    Image resizedImage;

    try {
      if (imageDecoded.width >= 1200 || imageDecoded.height > 1200) {
        if (imageDecoded.width >= imageDecoded.height) {
          resizedImage = copyResize(imageDecoded, 1200);
        } else {
          resizedImage = copyResize(imageDecoded, -1, 1200);
        }
      } else {
        resizedImage = imageDecoded;
      }

      Directory tempDir = await getTemporaryDirectory();
      String tempFilename = "${uuid.v4()}.jpg";
      File tempFile = await File("${tempDir.path}/$tempFilename")
          .writeAsBytes(encodeJpg(resizedImage, quality: 85));
      
      return tempFile;
    } catch (e) {
      print("processNewsImage error: $e");
      return null;
    }
  }

  

  static Future<void> deleteTempFile(File file) async {
      try {
        await file.delete();  
      } catch (e) {
        print("deleteTempFile error: $e");
      }
  }
}
