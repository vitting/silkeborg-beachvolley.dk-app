import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/bulletin_main.dart';
import 'package:silkeborgbeachvolley/ui/login/login_main.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/enrollment_main.dart';
import 'package:silkeborgbeachvolley/ui/scoreboard/scoreboard_main.dart';
import 'package:silkeborgbeachvolley/ui/settings/settings_main.dart';

void main() {

  
  runApp(new MaterialApp(
    title: 'Silkeborg Beachvolley',
    initialRoute: "/",
    routes: <String, WidgetBuilder>{ 
      "/": (BuildContext context) => Home(),
      // "/": (BuildContext context) => TestWidget(),
      "/enrollment": (BuildContext context) => Enrollment(),
      "/scoreboard": (BuildContext context) => ScoreBoard(),
      "/bulletin": (BuildContext context) => Bulletin(),
      "/login": (BuildContext context) => Login(),
      "/settings": (BuildContext context) => Settings()
    },
  ));
}
