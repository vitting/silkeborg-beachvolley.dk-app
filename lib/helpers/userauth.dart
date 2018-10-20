import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import "package:shared_preferences/shared_preferences.dart";

class UserAuth {
  static FirebaseAuth _firebaseAuth;
  static FacebookLogin _facebookSignIn;
  static Future<SharedPreferences> _sharedPrefs;

  static Future<SharedPreferences> get sharedPrefs {
    if (_sharedPrefs == null) {
      _sharedPrefs = SharedPreferences.getInstance();
    }

    return _sharedPrefs;
  }

  static FirebaseAuth get firebaseAuth {
    if (_firebaseAuth == null) {
      _firebaseAuth = FirebaseAuth.instance;
    }

    return _firebaseAuth;
  }

  static FacebookLogin get facebookSignIn {
    if (_facebookSignIn == null) {
      _facebookSignIn = new FacebookLogin();
    }

    return _facebookSignIn;
  }

  // If user is logged into Firebase.
  static Future<FirebaseUser> get currentUser async {
    return await firebaseAuth.currentUser();
  }

  //SignIn with Facebook credentials and signin user in Firebase Auth
  static Future<FirebaseUser> signInWithFacebook() async {
    const List<String> facebookPermissions = ["email"];

    FacebookLoginResult result =
        await facebookSignIn.logInWithReadPermissions(facebookPermissions);

    if (result.status == FacebookLoginStatus.cancelledByUser) return null;
    FirebaseUser user = await firebaseAuth.signInWithFacebook(
        accessToken: result.accessToken.token);
    return user;
  }

  //Signout facebook/firebase account
  static Future<bool> signOutWithFacebook() async {
    try {
      await facebookSignIn.logOut();
      await firebaseAuth.signOut();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
