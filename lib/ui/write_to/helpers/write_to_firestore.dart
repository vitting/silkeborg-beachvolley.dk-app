import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silkeborgbeachvolley/ui/write_to/helpers/write_to_data.dart';

class WriteToFirestore {
  static final _collectionName = "write_to_sbv";
  static final _collectionReplyName = "write_to_replies_sbv";
  static Firestore _firestore = Firestore.instance;

  static Future<void> setSendEmailReplyStatus(String id, bool status) {
    return _firestore
        .collection(_collectionReplyName)
        .document(id)
        .updateData({"sendToEmailStatus": status});
  }

  static Future<void> setSendEmailStatus(String id, bool status) {
    return _firestore
        .collection(_collectionName)
        .document(id)
        .updateData({"sendToEmailStatus": status});
  }

  static Future<void> setNewMessageStatus(String documentId, bool status) {
    return _firestore
        .collection(_collectionName)
        .document(documentId)
        .updateData({"newMessageStatus": status});
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

  static Future<List<WriteToData>> getAllMessages() async {
    List<WriteToData> list = [];
    QuerySnapshot snap1 = await _firestore
        .collection(_collectionName)
        .where("type", isEqualTo: "public")
        .where("deleted", isEqualTo: false)
        .orderBy("createdDate", descending: true)
        .getDocuments();

    QuerySnapshot snap2 = await _firestore
        .collection(_collectionName)
        .where("type", isEqualTo: "admin")
        .where("subType", isEqualTo: "message")
        .where("deleted", isEqualTo: false)
        .orderBy("createdDate", descending: true)
        .getDocuments();
    
    list.addAll(snap1.documents.map((DocumentSnapshot doc) {
      return WriteToData.fromMap(doc.data);
    }).toList());
    
    list.addAll(snap2.documents.map((DocumentSnapshot doc) {
      return WriteToData.fromMap(doc.data);
    }).toList());
    
    list.sort((WriteToData item1, WriteToData item2) {
      return item2.createdDate.compareTo(item1.createdDate);
    });

    return list;
  }

  static Stream<QuerySnapshot> getAllMessagesSentMailAsStream(int limit) {
    return _firestore
        .collection(_collectionName)
        .where("type", isEqualTo: "admin")
        .where("subType", isEqualTo: "mail")
        .where("deleted", isEqualTo: false)
        .orderBy("createdDate", descending: true)
        .limit(limit)
        .snapshots();
  }

  static Future<List<WriteToData>> getAllMessagesByUserId(String userId) async {
    List<WriteToData> list = [];
    QuerySnapshot snap1 = await _firestore
        .collection(_collectionName)
        .where("sendToUserId", isEqualTo: userId)
        .where("type", isEqualTo: "admin")
        .where("subType", isEqualTo: "message")
        .where("deleted", isEqualTo: false)
        .orderBy("createdDate", descending: true)
        .getDocuments();

    QuerySnapshot snap2 = await _firestore
        .collection(_collectionName)
        .where("fromUserId", isEqualTo: userId)
        .where("type", isEqualTo: "public")
        .where("deleted", isEqualTo: false)
        .orderBy("createdDate", descending: true)
        .getDocuments();
    
    list.addAll(snap1.documents.map((DocumentSnapshot doc) {
      return WriteToData.fromMap(doc.data);
    }).toList());
    
    list.addAll(snap2.documents.map((DocumentSnapshot doc) {
      return WriteToData.fromMap(doc.data);
    }).toList());
    
    list.sort((WriteToData item1, WriteToData item2) {
      return item2.createdDate.compareTo(item1.createdDate);
    });

    return list;
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
