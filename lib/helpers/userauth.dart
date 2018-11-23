import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class UserAuth {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static FacebookLogin _facebookSignIn;

  static FacebookLogin get facebookSignIn {
    if (_facebookSignIn == null) {
      _facebookSignIn = new FacebookLogin();
    }

    return _facebookSignIn;
  }

  // If user is logged into Firebase.
  static Future<FirebaseUser> get currentUser {
    return firebaseAuth.currentUser();
  }

  //SignIn with Facebook credentials and signin user in Firebase Auth
  static Future<FirebaseUser> signInWithFacebook() async {
    const List<String> facebookPermissions = ["email"];

    FacebookLoginResult result =
        await facebookSignIn.logInWithReadPermissions(facebookPermissions);

    if (result == null || result.status == FacebookLoginStatus.cancelledByUser)
      return null;
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
