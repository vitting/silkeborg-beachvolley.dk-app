import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/config_data.dart';
import 'package:silkeborgbeachvolley/helpers/notification_categories_enum.dart';
import 'package:silkeborgbeachvolley/helpers/notification_data.dart';
import 'package:silkeborgbeachvolley/helpers/system_helpers.dart';
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
    return (rebuild
            ? context.inheritFromWidgetOfExactType(_MainInherited)
                as _MainInherited
            : context.ancestorWidgetOfExactType(_MainInherited)
                as _MainInherited)
        .data;
  }
}

class MainInheritedState extends State<MainInherited> {
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  final StreamController<NotificationData> _notificationController =
      StreamController<NotificationData>.broadcast();
  UserMessagingData userMessaging;
  FirebaseUser loggedInUser;
  UserInfoData userInfoData;
  SettingsData settings;
  ConfigData config;
  bool canVibrate;
  bool isAdmin1 = false;
  bool isAdmin2 = false;
  bool isLoggedIn;
  bool isStartup = false;
  String systemLanguageCode = "en";

  SystemMode get modeProfile => widget.mode;

  Stream<NotificationData> get notificationsAsStream =>
      _notificationController.stream;

  void addNotification(NotificationData data) {
    _notificationController.add(data);
  }

  @override
  void initState() {
    super.initState();
    _initProperties();
    _initUserAuth();
    _initMessaging();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    config = await ConfigData.getConfig(context, modeProfile);
  }

  @override
  void dispose() {
    super.dispose();
    _notificationController.close();
  }

  void _initProperties() async {
    isStartup = widget.isStartup;
    canVibrate = widget.canVibrate;
    settings = widget.settings;
    loggedInUser = widget.user;
    isLoggedIn = widget.user != null ? true : false;
    isAdmin1 = widget.isAdmin1;
    isAdmin2 = widget.isAdmin2;
    userInfoData = widget.userInfoData;
  }

  void _initUserAuth() {
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

  void _initMessaging() async {
    systemLanguageCode = await SystemHelpers.systemLanguageCode();
    _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(alert: true, badge: true, sound: true));
    _firebaseMessaging.configure(

        ///OnLaunch er der ikke body og titel med. Bliver executed når appen er termineret
        onLaunch: (Map<String, dynamic> message) {
      NotificationData data;
      if (message != null) {
        data = NotificationData(
            type: message["dataType"] ?? "",
            bulletinType: message["bulletinType"] ?? "",
            state: NotificationState.launch);
      }

      addNotification(data);
    },

        ///OnMessage er der body og titel med. Bliver executed når appen er aktiv
        onMessage: (Map<String, dynamic> message) {
      NotificationData data;
      if (message != null && message["data"] != null) {
        data = NotificationData(
            type: message["data"]["dataType"] ?? "",
            bulletinType: message["data"]["bulletinType"] ?? "",
            state: NotificationState.message);
      }

      addNotification(data);
    },

        ///OnResume er der ikke body og titel med. Bliver executed når appen er minimeret
        onResume: (Map<String, dynamic> message) {
      NotificationData data;
      if (message != null) {
        data = NotificationData(
            type: message["dataType"] ?? "",
            bulletinType: message["bulletinType"] ?? "",
            state: NotificationState.resume);
      }

      addNotification(data);
    });

    _firebaseMessaging.onTokenRefresh.listen((token) {
      if (loggedInUser != null) {
        UserMessagingData userMessagingData = _createUserMessaging(token);
        userMessagingData.save();
        userMessaging = userMessagingData;
      }
    });

    await _firebaseMessaging.getToken();
  }

  UserMessagingData _createUserMessaging(String token) {
    ///Default categories
    List<NotificationCategory> categories = [];
    if (settings.notificationsShowNews) {
      categories.add(NotificationCategory.news);
    }

    if (settings.notificationsShowEvent) {
      categories.add(NotificationCategory.event);
    }

    if (settings.notificationsShowPlay) {
      categories.add(NotificationCategory.play);
    }

    UserMessagingData userMessagingData = UserMessagingData(
        userId: loggedInUser.uid,
        token: token,
        subscriptions: categories,
        languageCode: systemLanguageCode,
        isAdmin1: isAdmin1,
        isAdmin2: isAdmin2);

    return userMessagingData;
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
