import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:silkeborgbeachvolley/helpers/user_info_class.dart';
import 'package:silkeborgbeachvolley/helpers/user_messaging_data.dart';

class UserFirestore {
  static Firestore _firestore;
  static String _collectionNameUsers = "users";
  static String _collectionNameUsersMessaging = "users_messaging";

  static Firestore get firestoreInstance {
    if (_firestore == null) {
      _firestore = Firestore.instance;
    }
    return _firestore;
  }

  static Future<void> setUserMessaging(UserMessagingData item) {
    return firestoreInstance
        .collection(_collectionNameUsersMessaging)
        .document(item.userId)
        .setData(item.toMap());
  }

  static Future<void> deleteUserMessaging(String id) {
    return firestoreInstance
        .collection(_collectionNameUsersMessaging)
        .document(id)
        .delete();
  }

  static Future<DocumentSnapshot> getUserInfo(String id) {
    return firestoreInstance.collection("users").document(id).get();
  }

  static Future<void> addSubscriptionUserMessaging(
      String id, String subscription) {
    return firestoreInstance
        .collection(_collectionNameUsersMessaging)
        .document(id)
        .updateData({
      "subscriptions": FieldValue.arrayUnion([subscription])
    });
  }

  static Future<void> removeSubscriptionUserMessaging(
      String id, String subscription) {
    return firestoreInstance
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

    return firestoreInstance
        .collection(_collectionNameUsers)
        .document(user.uid)
        .setData(userInfo.toMap());
  }
}
