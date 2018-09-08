import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class BulletinFireStorage {
  static FirebaseStorage _firestorage;

  static FirebaseStorage get firestorageInstance {
    if (_firestorage == null) {
      _firestorage = FirebaseStorage.instance;
    }

    return _firestorage;
  }

  static Future<String> saveToFirebaseStorage(
      File file, String tempFilename, String imagesStoreageFolder) async {
    
    try {
      StorageUploadTask uploadTask = firestorageInstance
          .ref()
          .child("$imagesStoreageFolder/$tempFilename")
          .putFile(file);

      final UploadTaskSnapshot snapshot = await uploadTask.future;

      return snapshot.downloadUrl.toString();
    } catch (e) {
      print("saveToFirebaseStorage error: $e");
      return null;
    }
  }

  static Future<void> deleteFromFirebaseStorage(String filename, String imagesStoreageFolder) async {
    await firestorageInstance.ref().child("$imagesStoreageFolder/$filename").delete();
  }
}