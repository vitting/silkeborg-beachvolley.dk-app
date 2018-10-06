import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/admin/admin_enrollment_main.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/enrollment_main.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/bulletin_main.dart';
import 'package:silkeborgbeachvolley/ui/login/login_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/main/ranking_main.dart';
import 'package:silkeborgbeachvolley/ui/scoreboard/scoreboard_main.dart';
import 'package:silkeborgbeachvolley/ui/settings/settings_main.dart';
import 'package:silkeborgbeachvolley/ui/test.dart';
import 'package:silkeborgbeachvolley/ui/tournament_calendar/tournament_calendar_main.dart';

void main() {

  
  runApp(new MaterialApp(
    title: 'Silkeborg Beachvolley',
    theme: ThemeData(
      // primaryColor: Colors.yellow
    ),
    initialRoute: "/",
    routes: <String, WidgetBuilder>{ 
      "/": (BuildContext context) => Home(),
      // "/": (BuildContext context) => TestWidget(),
      Enrollment.routeName: (BuildContext context) => Enrollment(), 
      AdminEnrollment.routeName: (BuildContext context) => AdminEnrollment(),
      ScoreBoard.routeName: (BuildContext context) => ScoreBoard(),
      Bulletin.routeName: (BuildContext context) => Bulletin(),
      Login.routeName: (BuildContext context) => Login(),
      Settings.routeName: (BuildContext context) => Settings(),
      Ranking.routeName: (BuildContext context) => Ranking(),
      TournamentCalendar.routeName: (BuildContext context) => TournamentCalendar()
    },
  ));
}
