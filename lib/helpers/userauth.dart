import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import "package:shared_preferences/shared_preferences.dart";
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';

class UserAuth {
  static FirebaseAuth _firebaseAuth;
  // static GoogleSignIn _googleSignIn;
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

  // static GoogleSignIn get googleSignIn {
  //   if (_googleSignIn == null) {
  //     _googleSignIn = new GoogleSignIn();
  //   }

  //   return _googleSignIn;
  // }

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

  //SignIn with Google credentials and signin user in Firebase Auth
  // static Future<FirebaseUser> signInWithGoogle() async {
  //   final GoogleSignInAccount googleUser = await googleSignIn.signIn();
  //   if (googleUser == null) return null;

  //   final GoogleSignInAuthentication _googleAuth =
  //       await googleUser.authentication;
  //   final FirebaseUser user = await firebaseAuth.signInWithGoogle(
  //     accessToken: _googleAuth.accessToken,
  //     idToken: _googleAuth.idToken,
  //   );

  //   return user;
  // }

  //Signout google/firebase account
  // static Future<bool> signOutWithGoogle() async {
  //   try {
  //     await googleSignIn.signOut();
  //     await firebaseAuth.signOut();
  //     return true;
  //   } catch (e) {
  //     print(e);
  //     return false;
  //   }
  // }

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

  static String get loggedInUserId {
    return Home.loggedInUser.uid;
  }
}
