import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:silkeborgbeachvolley/helpers/user_info_data.dart';
import 'package:silkeborgbeachvolley/helpers/userauth.dart';
import 'package:silkeborgbeachvolley/ui/main_inheretedwidget.dart';
import 'package:silkeborgbeachvolley/ui/main_material_app.dart';
import 'package:silkeborgbeachvolley/ui/settings/helpers/settings_data.dart';
import 'package:vibrate/vibrate.dart';

void main() async {
  debugPaintSizeEnabled=false;
  debugPaintBaselinesEnabled=false;
  /// Set firestore to save and return dates as Timestamp
  final FirebaseApp app = FirebaseApp(name: "[DEFAULT]");
  final Firestore firestore = Firestore(app: app);
  await firestore.settings(timestampsInSnapshotsEnabled: true);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final bool canVibrate = await Vibrate.canVibrate;
  final FirebaseUser user = await UserAuth.currentUser;
  SettingsData settings;
  UserInfoData userInfoData;
  bool isAdmin1 = false;
  bool isAdmin2 = false;
  if (user != null) {
    settings = await SettingsData.initSettings(user);
    userInfoData = await UserInfoData.getUserInfo(user.uid);
    if (userInfoData != null) {
      isAdmin1 = userInfoData.admin1;
      isAdmin2 = userInfoData.admin2;
    }
  }
  
  runApp(MainInherited(
      mode: SystemMode.develop,
      isStartup: true,
      isAdmin1: isAdmin1,
      isAdmin2: isAdmin2,
      userInfoData: userInfoData,
      canVibrate: canVibrate,
      user: user,
      settings: settings,
      child: MainMaterialApp()));
}
