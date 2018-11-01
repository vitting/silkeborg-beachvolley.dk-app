import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silkeborgbeachvolley/ui/write_to_sbv/helpers/write_to_data.dart';

class WriteToFirestore {
  static final _collectionName = "write_to_sbv";
  static Firestore _firestore = Firestore.instance;

  static Future<void> saveMessage(WriteToData message) {
    return _firestore
        .collection(_collectionName)
        .document(message.id)
        .setData(message.toMap());
  }

  static Future<void> deleteMessage(String id) {
    return _firestore.collection(_collectionName).document(id).delete();
  }

  static Future<DocumentSnapshot> getMessage(String id) {
    return _firestore.collection(_collectionName).document(id).get();
  }

  static Future<QuerySnapshot> getAllMessages() {
    return _firestore
        .collection(_collectionName)
        .orderBy("createdDate")
        .getDocuments();
  }
}
