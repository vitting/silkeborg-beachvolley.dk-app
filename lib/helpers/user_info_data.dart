import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:silkeborgbeachvolley/helpers/user_firestore.dart';

class UserInfoData {
  String id;
  String name;
  String email;
  String photoUrl;

  ///Admin1
  bool admin1;
  bool admin2;
  UserInfoData(
      {@required this.id,
      @required this.name,
      @required this.photoUrl,
      @required this.email,
      this.admin1 = false,
      this.admin2 = false});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "admin1": admin1,
      "admin2": admin2,
      "name": name,
      "email": email,
      "photoUrl": photoUrl
    };
  }

  void updateUserInfoFromFirebaseUser(FirebaseUser user) {
    name = user.displayName;
    email = user.email;
    photoUrl = user.photoUrl;
  }

  Future<void> setAdmin1State(bool isAdmin) {
    admin1 = isAdmin;
    return UserFirestore.setAdminState(id, "admin1", isAdmin);
  }

  Future<void> setAdmin2State(bool isAdmin) {
    admin2 = isAdmin;
    return UserFirestore.setAdminState(id, "admin2", isAdmin);
  }

  static Future<UserInfoData> getUserInfo(String id) async {
    DocumentSnapshot snapshot = await UserFirestore.getUserInfo(id);
    UserInfoData userInfoData;
    if (snapshot.exists) userInfoData = UserInfoData.fromMap(snapshot.data);

    return userInfoData;
  }

  static Future<List<UserInfoData>> getAllUsers() async {
    List<UserInfoData> list = [];
    QuerySnapshot snapshot = await UserFirestore.getAllUsers();
    if (snapshot.documents.length != null) {
      list = snapshot.documents.map<UserInfoData>((DocumentSnapshot doc) {
        return UserInfoData.fromMap(doc.data);
      }).toList();
    }
    return list;
  }

  static UserInfoData fromFireBaseUser(FirebaseUser user) {
    return UserInfoData(
      id: user.uid,
      name: user.displayName,
      email: user.email,
      photoUrl: user.photoUrl,
    );
  }

  static Future<UserInfoData> initUserInfo(FirebaseUser user) async {
    UserInfoData userInfo;
    UserInfoData storedUserInfo = await UserInfoData.getUserInfo(user.uid);
    if (storedUserInfo != null) {
      userInfo = storedUserInfo..updateUserInfoFromFirebaseUser(user);
    } else {
      userInfo = UserInfoData.fromFireBaseUser(user);
    }

    await UserFirestore.setUserInfo(userInfo);

    return userInfo;
  }

  factory UserInfoData.fromMap(Map<String, dynamic> user) {
    return UserInfoData(
        id: user["id"] ?? "",
        name: user["name"] ?? "",
        email: user["email"] ?? "",
        photoUrl: user["photoUrl"] ?? "",
        admin1: user["admin1"] ?? false,
        admin2: user["admin2"] ?? false);
  }

  Future<void> delete() {
    return UserFirestore.deleteUser(id);
  }
}
