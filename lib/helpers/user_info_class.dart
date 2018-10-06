import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:silkeborgbeachvolley/helpers/base_data_class.dart';
import 'package:silkeborgbeachvolley/helpers/user_firestore.dart';

class UserInfoData implements BaseData {
  String id;
  String name;
  String email;
  String photoUrl;
  bool admin1;
  bool admin2;
  UserInfoData({@required this.id, @required this.name, @required this.photoUrl, @required this.email, this.admin1 = false, this.admin2 = false});
  
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

  static Future<UserInfoData> get(String id) async {
    DocumentSnapshot snapshot = await UserFirestore.getUserInfo(id);
    UserInfoData userInfoData;
    if (snapshot.exists)  userInfoData = UserInfoData.fromMap(snapshot.data);

    return userInfoData;
  }

  static UserInfoData fromFireBaseUser(FirebaseUser user) {
    return UserInfoData(
      id: user.uid,
      name: user.displayName,
      email: user.email,
      photoUrl: user.photoUrl,
    );

  }

  factory UserInfoData.fromMap (Map<String, dynamic> user) {
    return UserInfoData(
      id: user["id"] == null ? "" : user["id"],
      name: user["name"] == null ? "" : user["name"],
      email: user["email"] == null ? "" : user["email"],
      photoUrl: user["photoUrl"] == null ? "" : user["photoUrl"],
      admin1: user["admin1"] == null ? false : user["admin1"],
      admin2: user["admin2"] == null ? false : user["admin2"]
    );
  }

  @override
  Future<void> delete() async {
    // TODO: implement delete
  }

  @override
  Future<void> save() async {
    // TODO: implement save
  }
}
