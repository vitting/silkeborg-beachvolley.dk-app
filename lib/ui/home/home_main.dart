import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/notification_data.dart';
import 'package:silkeborgbeachvolley/helpers/user_messaging_data.dart';
import 'package:silkeborgbeachvolley/ui/main_inheretedwidget.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/main/bulletin_main.dart';
import 'package:silkeborgbeachvolley/ui/home/home_launcher_main.dart';
import 'package:silkeborgbeachvolley/ui/login/login_main.dart';
import './helpers/home_functions.dart' as homeFunctions;

class Home extends StatefulWidget {
  static UserMessagingData userMessaging;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  final StreamController<NotificationData> _notificationController =
      StreamController<NotificationData>.broadcast();
  Widget homeWidget = HomeLauncherSplash();

  @override
  void dispose() {
    super.dispose();
    _notificationController.close();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _init(context);
  }

  void _init(BuildContext context) async {
    if (MainInherited.of(context).loggedInUser != null) {
      await homeFunctions.initMessaging(
          MainInherited.of(context).loggedInUser,
          _firebaseMessaging,
          MainInherited.of(context).settings,
          _notificationController);
    }

    setState(() {
      homeWidget = MainInherited.of(context).isLoggedIn
          ? Bulletin(notificationController: _notificationController)
          : Login();
    });
  }

  @override
  Widget build(BuildContext context) {
    return homeWidget;
  }
}
