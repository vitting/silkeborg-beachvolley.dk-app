import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:silkeborgbeachvolley/helpers/image_info_data.dart';

class BulletinFireStorage {
  static FirebaseStorage _firestorage;

  static FirebaseStorage get firestorageInstance {
    if (_firestorage == null) {
      _firestorage = FirebaseStorage.instance;
    }

    return _firestorage;
  }

  static Future<ImageInfoData> saveImageToFirebaseStorage(
      ImageInfoData imageInfo) async {
    try {
      StorageUploadTask uploadTask = firestorageInstance
          .ref()
          .child("${imageInfo.imagesStoreageFolder}/${imageInfo.filename}")
          .putFile(imageInfo.imageFile);

      final StorageTaskSnapshot snapshot = await uploadTask.onComplete;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      imageInfo.linkFirebaseStorage = downloadUrl;
      return imageInfo;
    } catch (e) {
      print("saveToFirebaseStorage error: $e");
      return imageInfo;
    }
  }

  static Future<void> deleteFromFirebaseStorage(
      String filename, String imagesStoreageFolder) async {
    return await firestorageInstance
        .ref()
        .child("$imagesStoreageFolder/$filename")
        .delete();
  }
}
