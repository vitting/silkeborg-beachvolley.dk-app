import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silkeborgbeachvolley/ui/write_to/helpers/write_to_data.dart';

class WriteToFirestore {
  static final _collectionName = "write_to_sbv";
  static final _collectionReplyName = "write_to_replies_sbv";
  static Firestore _firestore = Firestore.instance;

  static Future<void> setSendEmailStatus(String id, bool status) {
    return _firestore
        .collection(_collectionName)
        .document(id)
        .updateData({"sendToEmailStatus": status});
  }

  static Future<void> saveMessage(WriteToData message) {
    return _firestore
        .collection(_collectionName)
        .document(message.id)
        .setData(message.toMap());
  }

  static Future<void> deleteMessage(String id) {
    return _firestore
        .collection(_collectionName)
        .document(id)
        .updateData({"deleted": true});
  }

  static Future<void> deleteAllReplyMessages(String messageRepliedToId) async {
    QuerySnapshot snapshot = await _firestore
        .collection(_collectionReplyName)
        .where("messageRepliedToId", isEqualTo: messageRepliedToId)
        .getDocuments();
    if (snapshot.documents.length != 0) {
      snapshot.documents.forEach((DocumentSnapshot doc) {
        doc.reference.delete();
      });
    }
  }

  static Future<DocumentSnapshot> getMessage(String id) {
    return _firestore.collection(_collectionName).document(id).get();
  }

  static Stream<QuerySnapshot> getAllMessages() {
    return _firestore
        .collection(_collectionName)
        .where("deleted", isEqualTo: false)
        .orderBy("createdDate", descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot> getAllMessagesByUserId(String userId) {
    return _firestore
        .collection(_collectionName)
        .where("fromUserId", isEqualTo: userId)
        .where("type", isEqualTo: "public")
        .where("deleted", isEqualTo: false)
        .orderBy("createdDate", descending: true)
        .snapshots();
  }

  static Future<void> saveReplyMessage(WriteToData replyMessage) {
    return _firestore
        .collection(_collectionReplyName)
        .document(replyMessage.id)
        .setData(replyMessage.toMap());
  }

  static Future<void> deleteReplyMessage(String id) {
    return _firestore
        .collection(_collectionReplyName)
        .document(id)
        .updateData({"deleted": true});
  }

  static Future<DocumentSnapshot> getReplyMessage(String id) {
    return _firestore.collection(_collectionReplyName).document(id).get();
  }

  static Stream<QuerySnapshot> getAllReplyMessage(String messageId) {
    return _firestore
        .collection(_collectionReplyName)
        .where("messageRepliedToId", isEqualTo: messageId)
        .where("deleted", isEqualTo: false)
        .orderBy("createdDate", descending: false)
        .snapshots();
  }
}
