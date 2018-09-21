import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:silkeborgbeachvolley/helpers/image_info_data_class.dart';

class BulletinFireStorage {
  static FirebaseStorage _firestorage;

  static FirebaseStorage get firestorageInstance {
    if (_firestorage == null) {
      _firestorage = FirebaseStorage.instance;
    }

    return _firestorage;
  }

  static Future<ImageInfoData> saveImageToFirebaseStorage(ImageInfoData imageInfo) async {
    
    try {
      StorageUploadTask uploadTask = firestorageInstance
          .ref()
          .child("${imageInfo.imagesStoreageFolder}/${imageInfo.filename}")
          .putFile(imageInfo.imageFile);

      final UploadTaskSnapshot snapshot = await uploadTask.future;
      imageInfo.linkFirebaseStorage = snapshot.downloadUrl.toString();
      return imageInfo;
    } catch (e) {
      print("saveToFirebaseStorage error: $e");
      return imageInfo;
    }
  }

  static Future<void> deleteFromFirebaseStorage(String filename, String imagesStoreageFolder) async {
    return await firestorageInstance.ref().child("$imagesStoreageFolder/$filename").delete();
  }
}