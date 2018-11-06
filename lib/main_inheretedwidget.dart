import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/user_info_data.dart';
import 'package:silkeborgbeachvolley/helpers/user_messaging_data.dart';
import 'package:silkeborgbeachvolley/ui/settings/helpers/settings_data.dart';

enum SystemMode {
  release,
  develop
}

class MainInherited extends StatefulWidget {
  final Widget child;
  final SystemMode mode;

  MainInherited({this.child, this.mode});

  @override
  MainInheritedState createState() => new MainInheritedState();

  static MainInheritedState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_MainInherited) as _MainInherited).data;
  }
}

class MainInheritedState extends State<MainInherited> {
  FirebaseUser loggedInUser;
  UserInfoData userInfo;
  SettingsData settings;
  UserMessagingData userMessaging;
  bool canVibrate;
  SystemMode get modeProfile => widget.mode;

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