import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsFirestore {
  static Firestore _firestore = Firestore.instance;
  static final _collectionName = "notifications";

  static Future<void> setShownState(String docId, String userId) {
    return _firestore
        .collection(_collectionName)
        .document(docId)
        .updateData({"userIds": FieldValue.arrayRemove([userId])});
  }

  static Future<QuerySnapshot> getNotificationsFromUserId(String userId) {
    return _firestore
        .collection(_collectionName)
        .where("userIds", arrayContains: userId)
        .where("shown", isEqualTo: false)
        .orderBy("creationDate", descending: true)
        .getDocuments();
  }
}
