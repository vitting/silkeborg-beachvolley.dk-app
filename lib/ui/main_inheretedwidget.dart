import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/config_data.dart';
import 'package:silkeborgbeachvolley/helpers/notification_categories_enum.dart';
import 'package:silkeborgbeachvolley/helpers/notification_data.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_theme.dart';
import 'package:silkeborgbeachvolley/helpers/system_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/user_info_data.dart';
import 'package:silkeborgbeachvolley/helpers/user_messaging_data.dart';
import 'package:silkeborgbeachvolley/helpers/userauth.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_widget.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_sharedpref.dart';
import 'package:silkeborgbeachvolley/ui/settings/helpers/settings_data.dart';

enum SystemMode { release, develop }

class MainInherited extends StatefulWidget {
  ///Child widget to this root widget
  final Widget child;

  ///Indicate if we are developing or running a release
  final SystemMode mode;

  ///Indicate if this device can vibrate
  final bool canVibrate;

  MainInherited({
    this.child,
    this.mode,
    this.canVibrate = false,
  });

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
  String systemLanguageCode = "en";
  String userId;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initProperties();
    _initUserAuth();
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

  SystemMode get modeProfile => widget.mode;

  Stream<NotificationData> get notificationsAsStream =>
      _notificationController.stream;

  void addNotification(NotificationData data) {
    _notificationController.add(data);
  }

  Future<bool> deleteFirebaseMessagingSession() {
    return _firebaseMessaging.deleteInstanceID();
  }

  Future<void> logout() async {
    isLoggedIn = false;
    await _firebaseMessaging.deleteInstanceID();
    await UserMessagingData.deleteUserMessaging(userId);
    await UserInfoData.setEnabledState(userId, false);
    await RankingSharedPref.removeIsItFirstTime();
    await UserAuth.signOutWithFacebook();
  }

  Future<void> _initProperties() async {
    canVibrate = widget.canVibrate;
  }

  Future<void> _initUserAuth() async {
    UserAuth.firebaseAuth.onAuthStateChanged.listen((user) async {
      loggedInUser = user;
      userId = user?.uid;
      isLoggedIn = user != null ? true : false;

      if (user != null) {
        print("**********************INITUSERAUTH**********************");
        userInfoData = await UserInfoData.initUserInfo(user);
        isAdmin1 = userInfoData.admin1;
        isAdmin2 = userInfoData.admin2;
        settings = await SettingsData.initSettings(user);
        _initMessaging();
      }

      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    });
  }

  Future<void> _initMessaging() async {
    systemLanguageCode = await SystemHelpers.systemLanguageCode();
    _firebaseMessaging.setAutoInitEnabled(true);
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(alert: true, badge: true, sound: true));
    _firebaseMessaging.configure(

        ///OnLaunch er der ikke body og titel med. Bliver executed når appen er termineret
        onLaunch: (Map<String, dynamic> message) {
      print("******************ONLAUNCH*****************");
      print(message);
      NotificationData data;
      if (message != null) {
        data = NotificationData(
            type: message["dataType"] ?? "",
            subType: message["subType"] ?? "",
            state: NotificationState.launch);
      }

      addNotification(data);
    },

        ///OnMessage er der body og titel med. Bliver executed når appen er aktiv
        onMessage: (Map<String, dynamic> message) {
      print("******************ONMESSAGE*****************");
      print(message);
      NotificationData data;
      if (message != null && message["data"] != null) {
        data = NotificationData(
            type: message["data"]["dataType"] ?? "",
            subType: message["data"]["subType"] ?? "",
            state: NotificationState.message);
      }

      addNotification(data);
    },

        ///OnResume er der ikke body og titel med. Bliver executed når appen er minimeret
        onResume: (Map<String, dynamic> message) {
      print("******************ONRESUME*****************");
      print(message);
      NotificationData data;
      if (message != null) {
        data = NotificationData(
            type: message["dataType"] ?? "",
            subType: message["subType"] ?? "",
            state: NotificationState.resume);
      }

      addNotification(data);
    });

    _firebaseMessaging.onTokenRefresh.listen((token) {
      if (isLoggedIn) {
        print("**********************Token refresh*********************");
        this.userMessaging = _initUserMessaging(token);
      }
    });

    await _firebaseMessaging.getToken();
  }

  UserMessagingData _initUserMessaging(String token) {
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

    if (settings.notificationsShowWriteTo) {
      categories.add(NotificationCategory.writeTo);
    }

    if (userInfoData.admin2) {
      if (settings.notificationsShowWriteToAdmin) {
        categories.add(NotificationCategory.writeToAdmin);
      }
    }

    UserMessagingData userMessagingData = UserMessagingData(
        userId: loggedInUser.uid,
        token: token,
        subscriptions: categories,
        languageCode: systemLanguageCode,
        isAdmin1: isAdmin1,
        isAdmin2: isAdmin2);

    userMessagingData.save();
    return userMessagingData;
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Container(
            decoration: SilkeborgBeachvolleyTheme.gradientColorBoxDecoration,
            // color: Colors.yellow,
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset("assets/images/logo_white_with_text_210x200.png"),
                LoaderSpinner()
              ],
            )),
          )
        : new _MainInherited(
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
