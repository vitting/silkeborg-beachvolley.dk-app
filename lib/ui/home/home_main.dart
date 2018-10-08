import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/loader_spinner_overlay_widget.dart';
import 'package:silkeborgbeachvolley/helpers/user_info_class.dart';
import 'package:silkeborgbeachvolley/helpers/userauth.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/bulletin_main.dart';
import 'package:silkeborgbeachvolley/ui/login/login_main.dart';
import 'package:silkeborgbeachvolley/ui/settings/helpers/settings_data_class.dart';

class Home extends StatefulWidget {
  static FirebaseUser loggedInUser;
  static UserInfoData userInfo;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isLoggedIn = false;
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    print("LOGIN START: ${DateTime.now().millisecond}");
    UserAuth.firebaseAuth.onAuthStateChanged.listen((user) {
      Home.loggedInUser = user;
      if (user != null) {
        _loadUserInfo(user.uid);
        _initSettings(user.uid);
      }

      if (mounted) {
        setState(() {
          _loading = false;
          print("LOGIN SLUT: ${DateTime.now().millisecond}");
          _isLoggedIn = user == null ? false : true;
        });
      }
    });
  }

  void _initSettings(String userId) async {
    SettingsData settings = await SettingsData.get(userId);
    if (settings == null) {
      settings = SettingsData(rankingName: Home.loggedInUser.displayName);
      settings.save();
    }
  }

  void _loadUserInfo(String userId) async {
    UserInfoData userInfoData = await UserInfoData.get(userId);
    if (mounted) {
      setState(() {
        Home.userInfo = userInfoData;
      });
    }
  }

  ///CHRISTIAN: Vi gemmer devicetoken ved ontoken refresh. Hvis den kører ved getToken.
  ///

///CHRISTIAN: Det vi kan gøre er at så længe vi er i loading fase så vise vi en splashscreen
///Når vi så ved hvad vi skal vise: Bulletin / Login så viser vi det...
  @override
  Widget build(BuildContext context) {
    return LoaderSpinnerOverlay(
        show: _loading, child: _isLoggedIn ? Bulletin() : Login());
  }
}
