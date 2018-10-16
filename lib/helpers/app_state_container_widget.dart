import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/user_info_data.dart';
import 'package:silkeborgbeachvolley/helpers/user_messaging_data.dart';
import 'package:silkeborgbeachvolley/ui/settings/helpers/settings_data.dart';

class AppState {
  FirebaseUser loggedInUser;
  UserInfoData userInfo;
  SettingsData settings;
  UserMessagingData userMessaging;
  AppState({this.loggedInUser, this.userInfo, this.settings, this.userMessaging});
}

class AppStateContainer extends StatefulWidget {
  final Widget child;

  AppStateContainer({
    @required this.child,
  });

  static _AppStateContainerState of(
      [BuildContext context, bool rebuild = true]) {
    return rebuild
        ? (context.inheritFromWidgetOfExactType(_InheritedStateContainer)
                as _InheritedStateContainer)
            .data
        : (context.ancestorWidgetOfExactType(_InheritedStateContainer)
                as _InheritedStateContainer)
            .data;
  }

  @override
  _AppStateContainerState createState() => new _AppStateContainerState();
}

class _AppStateContainerState extends State<AppStateContainer> {
  AppState state;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}

class _InheritedStateContainer extends InheritedWidget {
  final _AppStateContainerState data;

  _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}
