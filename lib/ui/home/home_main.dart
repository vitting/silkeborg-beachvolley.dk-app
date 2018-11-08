import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/user_messaging_data.dart';
import 'package:silkeborgbeachvolley/ui/main_inheretedwidget.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/main/bulletin_main.dart';
import 'package:silkeborgbeachvolley/ui/home/home_launcher_main.dart';
import 'package:silkeborgbeachvolley/ui/login/login_main.dart';

class Home extends StatefulWidget {
  static UserMessagingData userMessaging;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget homeWidget = HomeLauncherSplash();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      homeWidget = MainInherited.of(context).isLoggedIn ? Bulletin() : Login();
    });
  }

  @override
  Widget build(BuildContext context) {
    return homeWidget;
  }
}
