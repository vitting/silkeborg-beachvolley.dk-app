import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/config_data.dart';
import 'package:silkeborgbeachvolley/helpers/user_info_data.dart';
import 'package:silkeborgbeachvolley/helpers/user_messaging_data.dart';
import 'package:silkeborgbeachvolley/helpers/userauth.dart';
import 'package:silkeborgbeachvolley/ui/settings/helpers/settings_data.dart';

enum SystemMode { release, develop }

class MainInherited extends StatefulWidget {
  ///Child widget to this root widget
  final Widget child;

  ///Indicate if we are developing or running a release
  final SystemMode mode;

  ///Indicate if this device can vibrate
  final bool canVibrate;

  ///user from Firebase auth. Null if we isn't logged in.
  final FirebaseUser user;

  ///User info data
  final UserInfoData userInfoData;

  ///Settings for the app
  final SettingsData settings;

  ///Is the logged in user admin1
  final bool isAdmin1;

  ///Is the logged in user admin2
  final bool isAdmin2;

  ///Is this app starting up
  final bool isStartup;

  MainInherited(
      {this.child,
      this.mode,
      this.canVibrate = false,
      this.user,
      this.settings,
      this.isAdmin1 = false,
      this.isAdmin2 = false,
      this.userInfoData,
      this.isStartup = false});

  @override
  MainInheritedState createState() => new MainInheritedState();

  static MainInheritedState of([BuildContext context, bool rebuild = true]) {
    return (rebuild ? context.inheritFromWidgetOfExactType(_MainInherited) as _MainInherited
                    : context.ancestorWidgetOfExactType(_MainInherited) as _MainInherited).data;
  }
}

class MainInheritedState extends State<MainInherited> {
  FirebaseUser loggedInUser;
  UserInfoData userInfoData;
  SettingsData settings;
  UserMessagingData userMessaging;
  ConfigData config;
  bool canVibrate;
  bool isAdmin1 = false;
  bool isAdmin2 = false;
  bool isLoggedIn;
  bool isStartup = false;

  SystemMode get modeProfile => widget.mode;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    isStartup = widget.isStartup;
    canVibrate = widget.canVibrate;
    settings = widget.settings;
    loggedInUser = widget.user;
    isLoggedIn = widget.user != null ? true : false;
    isAdmin1 = widget.isAdmin1;
    isAdmin2 = widget.isAdmin2;
    userInfoData = widget.userInfoData;

    UserAuth.firebaseAuth.onAuthStateChanged.listen((user) async {
      if (!isStartup && user != null) {
        userInfoData = await UserInfoData.getUserInfo(user.uid);
        isAdmin1 = userInfoData.admin1;
        isAdmin2 = userInfoData.admin2;
        settings = await SettingsData.initSettings(user);
      }

      if (mounted) {
        setState(() {
          loggedInUser = user;
          isLoggedIn = user != null ? true : false;
        });
      }

      isStartup = false;
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    config = await ConfigData.getConfig(context, modeProfile);
  }

  @override
  Widget build(BuildContext context) {
    return new _MainInherited(
      data: this,
      child: widget.child,
    );
  }
}

class _MainInherited extends InheritedWidget {
  final MainInheritedState data;

  _MainInherited({Key key, this.data, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_MainInherited old) {
    return true;
  }
}
