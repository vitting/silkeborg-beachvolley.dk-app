import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/notification_data.dart';
import 'package:silkeborgbeachvolley/helpers/user_info_data.dart';
import 'package:silkeborgbeachvolley/helpers/user_messaging_data.dart';
import 'package:silkeborgbeachvolley/helpers/userauth.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/main/bulletin_main.dart';
import 'package:silkeborgbeachvolley/ui/home/home_launcher_main.dart';
import 'package:silkeborgbeachvolley/ui/login/login_main.dart';
import 'package:silkeborgbeachvolley/ui/settings/helpers/settings_data.dart';
import './helpers/home_functions.dart' as homeFunctions;

class Home extends StatefulWidget {
  static FirebaseUser loggedInUser;
  static UserInfoData userInfo;
  static SettingsData settings;
  static UserMessagingData userMessaging;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  final StreamController<NotificationData> _notificationController =
      StreamController<NotificationData>.broadcast();
  bool _isLoggedIn = false;
  Widget homeWidget = HomeLauncherSplash();
  
  @override
  void dispose() {
    super.dispose();
    _notificationController.close();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _init(context));
  }

  _init(BuildContext context) {
    UserAuth.firebaseAuth.onAuthStateChanged.listen((user) async {
      Home.loggedInUser = user;
      SettingsData settings;
      UserInfoData userInfoData;

      if (user != null) {
        userInfoData = await homeFunctions.loadUserInfo(user.uid);
        settings = await homeFunctions.initSettings(user.uid, user.displayName);
        await homeFunctions.initMessaging(
            user.uid, _firebaseMessaging, settings, _notificationController);
      }

      if (mounted) {
        setState(() {
          Home.userInfo = userInfoData;
          Home.settings = settings;
          _isLoggedIn = user == null ? false : true;
          homeWidget = _isLoggedIn
              ? Bulletin(notificationController: _notificationController)
              : Login();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return homeWidget;
  }
}
