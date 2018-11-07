import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:silkeborgbeachvolley/helpers/user_info_data.dart';
import 'package:silkeborgbeachvolley/helpers/userauth.dart';
import 'package:silkeborgbeachvolley/main_inheretedwidget.dart';
import 'package:silkeborgbeachvolley/main_material_app.dart';
import 'package:silkeborgbeachvolley/ui/settings/helpers/settings_data.dart';
import 'package:vibrate/vibrate.dart';

void main() async {
  // debugPaintSizeEnabled=true;
  // debugPaintBaselinesEnabled=true;
  /// Set firestore to save and return dates as Timestamp
  final FirebaseApp app = FirebaseApp(name: "[DEFAULT]");
  final Firestore firestore = Firestore(app: app);
  await firestore.settings(timestampsInSnapshotsEnabled: true);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final FirebaseUser firebaseUser = await UserAuth.currentUser;
  final bool canVibrate = await Vibrate.canVibrate;
  SettingsData settings;
  bool admin1 = false;
  bool admin2 = false;
  bool isLoggedIn = false;
  
  if (firebaseUser != null) {
    UserInfoData userInfoData = await UserInfoData.getUserInfo(firebaseUser.uid);
    admin1 = userInfoData.admin1;
    admin2 = userInfoData.admin2;
    isLoggedIn = true;
    settings = await SettingsData.initSettings(firebaseUser.uid, firebaseUser.displayName);
  }

  runApp(MainInherited(
    mode: SystemMode.develop,
    loggedInUser: firebaseUser,
    admin1: admin1,
    admin2: admin2,
    isLoggedIn: isLoggedIn,
    settings: settings,
    canVibrate: canVibrate,
    child: MainMaterialApp()
  ));
}
