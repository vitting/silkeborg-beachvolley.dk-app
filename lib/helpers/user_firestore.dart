import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silkeborgbeachvolley/helpers/user_info_data.dart';
import 'package:silkeborgbeachvolley/helpers/user_messaging_data.dart';

class UserFirestore {
  static Firestore _firestore = Firestore.instance;
  static String _collectionNameUsers = "users";
  static String _collectionNameUsersMessaging = "users_messaging";

  static Future<QuerySnapshot> getAllUsers() {
    return _firestore
        .collection(_collectionNameUsers)
        .orderBy("name")
        .getDocuments();
  }

  static Future<void> deleteUser(String userId) {
    return _firestore
        .collection(_collectionNameUsers)
        .document(userId)
        .delete();
  }

  static Future<void> setAdminState(
      String userId, String adminType, bool isAdmin) {
    String messagingAdminType = adminType == "admin1" ? "isAdmin1" : "isAdmin2";
    setUserMessagingAdminState(userId, messagingAdminType, isAdmin);

    return _firestore
        .collection(_collectionNameUsers)
        .document(userId)
        .updateData({"$adminType": isAdmin});
  }

  static Future<void> setUserMessagingAdminState(
      String userId, String adminType, bool isAdmin) {
    return _firestore
        .collection(_collectionNameUsersMessaging)
        .document(userId)
        .updateData({"$adminType": isAdmin});
  }

  static Future<DocumentSnapshot> getUserMessaging(String id) {
    return _firestore
        .collection(_collectionNameUsersMessaging)
        .document(id)
        .get();
  }

  static Future<void> setUserMessaging(UserMessagingData item) {
    return _firestore
        .collection(_collectionNameUsersMessaging)
        .document(item.userId)
        .setData(item.toMap());
  }

  static Future<void> deleteUserMessaging(String userId) {
    return _firestore
        .collection(_collectionNameUsersMessaging)
        .document(userId)
        .delete();
  }

  static Future<DocumentSnapshot> getUserInfo(String id) {
    return _firestore.collection("users").document(id).get();
  }

  static Future<void> addSubscriptionUserMessaging(
      String id, String subscription) {
    return _firestore
        .collection(_collectionNameUsersMessaging)
        .document(id)
        .updateData({
      "subscriptions": FieldValue.arrayUnion([subscription])
    });
  }

  static Future<void> removeSubscriptionUserMessaging(
      String id, String subscription) {
    return _firestore
        .collection(_collectionNameUsersMessaging)
        .document(id)
        .updateData({
      "subscriptions": FieldValue.arrayRemove([subscription])
    });
  }

  static Future<void> setUserInfo(UserInfoData userInfo) {
    return _firestore
        .collection(_collectionNameUsers)
        .document(userInfo.id)
        .setData(userInfo.toMap());
  }

  static Future<void> enabled(String userId, bool enabled) {
    return _firestore
        .collection(_collectionNameUsers)
        .document(userId)
        .updateData({"enabled": enabled});
  }
}
