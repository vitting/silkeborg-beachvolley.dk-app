import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/enrollment_stepper_main.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/bulletin_main.dart';
import 'package:silkeborgbeachvolley/ui/login/login_main.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/enrollment_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/ranking_main.dart';
import 'package:silkeborgbeachvolley/ui/scoreboard/scoreboard_main.dart';
import 'package:silkeborgbeachvolley/ui/settings/settings_main.dart';
import 'package:silkeborgbeachvolley/ui/testers/test3.dart';
import 'package:silkeborgbeachvolley/ui/test.dart';

void main() {

  
  runApp(new MaterialApp(
    title: 'Silkeborg Beachvolley',
    theme: ThemeData(
      // primaryColor: Colors.yellow
    ),
    initialRoute: "/",
    onUnknownRoute: (RouteSettings v) {
      print("ROUTE: ${v.name}");
    },
    onGenerateRoute: (RouteSettings v) {
      print("ROUTE: ${v.name}");
    },
    routes: <String, WidgetBuilder>{ 
      "/": (BuildContext context) => Home(),
      // "/": (BuildContext context) => FancyFab(),
      // "/": (BuildContext context) => TestWidget(),
      Enrollment.routeName: (BuildContext context) => Enrollment(),
      EnrollmentStepper.routeName: (BuildContext context) => EnrollmentStepper(), 
      ScoreBoard.routeName: (BuildContext context) => ScoreBoard(),
      Bulletin.routeName: (BuildContext context) => Bulletin(),
      Login.routeName: (BuildContext context) => Login(),
      Settings.routeName: (BuildContext context) => Settings(),
      Ranking.routeName: (BuildContext context) => Ranking()
    },
  ));
}
