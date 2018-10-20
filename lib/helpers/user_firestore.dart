import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:silkeborgbeachvolley/helpers/user_info_data.dart';
import 'package:silkeborgbeachvolley/helpers/user_messaging_data.dart';

class UserFirestore {
  static Firestore _firestore = Firestore.instance;
  static String _collectionNameUsers = "users";
  static String _collectionNameUsersMessaging = "users_messaging";

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

  static Future<void> deleteUserMessaging(String id) {
    return _firestore
        .collection(_collectionNameUsersMessaging)
        .document(id)
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

  static Future<void> setUserInfo(FirebaseUser user) async {
    UserInfoData userInfo;
    UserInfoData storedUserInfo = await UserInfoData.get(user.uid);
    if (storedUserInfo != null) {
      userInfo = storedUserInfo..updateUserInfoFromFirebaseUser(user);
    } else {
      userInfo = UserInfoData.fromFireBaseUser(user);
    }

    return _firestore
        .collection(_collectionNameUsers)
        .document(user.uid)
        .setData(userInfo.toMap());
  }
}
