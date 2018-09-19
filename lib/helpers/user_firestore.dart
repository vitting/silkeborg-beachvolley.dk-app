import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:silkeborgbeachvolley/helpers/user_info_class.dart';

class UserFirestore {
  static Firestore _firestore;

  static Firestore get firestoreInstance {
    if (_firestore == null) {
      _firestore = Firestore.instance;
    }
    return _firestore;
  }

  static Future<DocumentSnapshot> getUserInfo(String id) {
    return firestoreInstance.collection("users").document(id).get();
  } 

  static Future<void> setUserInfo(FirebaseUser user) async {
    UserInfoData userInfo;
    UserInfoData storedUserInfo = await UserInfoData.getStoredUserInfo(user.uid);
    if (storedUserInfo != null) {
      userInfo = storedUserInfo..updateUserInfoFromFirebaseUser(user);
    } else {
      userInfo = UserInfoData.fromFireBaseUser(user);
    }
    
    await firestoreInstance.collection("users").document(user.uid).setData(userInfo.toMap());
  }
}