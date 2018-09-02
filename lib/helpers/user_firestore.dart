import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:silkeborgbeachvolley/helpers/user_info_firebase_class.dart';

class UserFirestore {
  static Firestore _firestore;

  static Firestore get firestoreInstance {
    if (_firestore == null) {
      _firestore = Firestore.instance;
    }

    return _firestore;
  }

  static Future<void> setUserInfo(FirebaseUser user) async {
    await firestoreInstance.collection("users").document(user.uid).setData(
      {
        "displayName": user.displayName,
        "email": user.email,
        "photoUrl": user.photoUrl
      }
    );
  }

  static Future<void> updateUserInfo(String userId, UserInfoFirebase user) async {
    return await firestoreInstance.collection("users").document(userId).setData(user.toMap());
  }
}