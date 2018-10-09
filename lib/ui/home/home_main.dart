
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/user_info_class.dart';
import 'package:silkeborgbeachvolley/helpers/userauth.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/bulletin_main.dart';
import 'package:silkeborgbeachvolley/ui/home/home_launcher_main.dart';
import 'package:silkeborgbeachvolley/ui/login/login_main.dart';
import 'package:silkeborgbeachvolley/ui/settings/helpers/settings_data_class.dart';
import './home_functions.dart' as homeFunctions;

class Home extends StatefulWidget {
  static FirebaseUser loggedInUser;
  static UserInfoData userInfo;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  bool _isLoggedIn = false;
  Widget homeWidget = HomeLauncherSplash();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _init(context));
  }

  _init(BuildContext context) {
    UserAuth.firebaseAuth.onAuthStateChanged.listen((user) async {
      Home.loggedInUser = user;
      UserInfoData userInfoData;

      if (user != null) {
        userInfoData = await homeFunctions.loadUserInfo(user.uid);
        SettingsData settings = await homeFunctions.initSettings(user.uid, user.displayName);
        await homeFunctions.initMessaging(user.uid, _firebaseMessaging, settings);
      }

      if (mounted) {
        setState(() {
          Home.userInfo = userInfoData;
          _isLoggedIn = user == null ? false : true;
          homeWidget = _isLoggedIn ? Bulletin() : Login();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return homeWidget;
  }
}
