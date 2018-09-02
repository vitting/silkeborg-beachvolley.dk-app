import 'package:firebase_auth/firebase_auth.dart';

class UserInfoFirebase {
  String _id = "";
  String _displayName = "";
  String _email = "";
  String _photoUrl = "";
  bool _admin1 = false;
  bool _admin2 = false;
  UserInfoFirebase({String id, String displayName, String email, String photoUrl}) {
    _id = id;
    _displayName = displayName;
    _email = email;
    _photoUrl = photoUrl;
  }
  
  Map<String, dynamic> toMap() {
    return {
      "admin1": _admin1,
      "admin2": _admin2,
      "displayName": _displayName,
      "email": _email,
      "photoUrl": _photoUrl
    };
  }

  fromFireBaseUser(FirebaseUser user) {
    _id = user.uid;
    _displayName = user.displayName;
    _email = user.email;
    _photoUrl = user.photoUrl;

  }

  fromMap(Map<String, dynamic> user) {
    _displayName = user["displayName"];
    _email = user["email"];
    _photoUrl = user["photoUrl"];
    _admin1 = user["admin1"];
    _admin2 = user["admin2"];
  }

  String get id => _id;
  set userId(String id) {
    _id = id;
  }
}
