import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsFirestore {
  static Firestore _firestore = Firestore.instance;
  static final _collectionName = "notifications";

  static Future<void> setShownState(String docId, bool state) {
    return _firestore.collection(_collectionName).document(docId).updateData({
      "shown": state
    });
  }

  static Future<QuerySnapshot> getNotificationsFromUserId(String userId) {
    return _firestore.collection(_collectionName).where("userId", isEqualTo: userId).orderBy("creationDate", descending: true).getDocuments();
  }
}