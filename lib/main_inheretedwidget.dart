import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/config_data.dart';
import 'package:silkeborgbeachvolley/helpers/user_messaging_data.dart';
import 'package:silkeborgbeachvolley/helpers/userauth.dart';
import 'package:silkeborgbeachvolley/ui/settings/helpers/settings_data.dart';

enum SystemMode {
  release,
  develop
}

class MainInherited extends StatefulWidget {
  final Widget child;
  final SystemMode mode;
  final FirebaseUser loggedInUser;
  final bool canVibrate;
  final bool admin1;
  final bool admin2;
  final bool isLoggedIn;
  final SettingsData settings;

  MainInherited({this.child, this.mode, this.loggedInUser, this.canVibrate = false, this.admin1 = false, this.admin2 = false, this.settings, this.isLoggedIn = false});

  @override
  MainInheritedState createState() => new MainInheritedState();

  static MainInheritedState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_MainInherited) as _MainInherited).data;
  }
}

class MainInheritedState extends State<MainInherited> {
  FirebaseUser loggedInUser;
  SettingsData settings;
  UserMessagingData userMessaging;
  ConfigData config;
  bool canVibrate;
  bool admin1;
  bool admin2;
  bool isLoggedIn;

  SystemMode get modeProfile => widget.mode;
  
   @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    print("INIT INHERETED WIDGET");

    loggedInUser = widget.loggedInUser;    
    canVibrate = widget.canVibrate;
    admin1 = widget.admin1;
    admin2 = widget.admin2;
    settings = widget.settings;
    isLoggedIn = widget.isLoggedIn;
    
    UserAuth.firebaseAuth.onAuthStateChanged.listen((user) {
      loggedInUser = user;
      isLoggedIn = user != null ? true : false;
    });
  }

  @override
    void didChangeDependencies() async {
      super.didChangeDependencies();
      config = await ConfigData.getConfig(context, modeProfile);
    }

  // _init(BuildContext context) {
  //   UserAuth.firebaseAuth.onAuthStateChanged.listen((user) async {
  //     // MainInherited.of(context).loggedInUser = user;
  //     Home.loggedInUser = user;
  //     SettingsData settings;
  //     UserInfoData userInfoData;
  //     bool canPhoneVibrate = await Vibrate.canVibrate;

  //     if (user != null) {
  //       userInfoData = await UserInfoData.getUserInfo(user.uid);
  //       settings = await homeFunctions.initSettings(user.uid, user.displayName);
  //       await homeFunctions.initMessaging(
  //           user.uid, _firebaseMessaging, settings, _notificationController);
  //     }

  //     if (mounted) {
  //       setState(() {
  //         Home.userInfo = userInfoData;
  //         Home.settings = settings;
  //         Home.canVibrate = canPhoneVibrate;
  //         _isLoggedIn = user == null ? false : true;
  //         homeWidget = _isLoggedIn
  //             ? Bulletin(notificationController: _notificationController)
  //             : Login();
  //       });
  //     }
  //   });
  // }

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

  _MainInherited({Key key, this.data, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_MainInherited old) {
    return true;
  }
}