import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/enrollment_main.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/bulletin_main.dart';
import 'package:silkeborgbeachvolley/ui/login/login_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/main/ranking_main.dart';
import 'package:silkeborgbeachvolley/ui/scoreboard/scoreboard_main.dart';
import 'package:silkeborgbeachvolley/ui/settings/settings_main.dart';
// import 'package:silkeborgbeachvolley/ui/testers/test3.dart';
import 'package:silkeborgbeachvolley/ui/test.dart';
import 'package:silkeborgbeachvolley/ui/testers/test1.dart';
import 'package:silkeborgbeachvolley/ui/tournament_calendar/tournament_calendar_main.dart';

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
      // "/": (BuildContext context) => TestWidget(),
      // "/": (BuildContext context) => Test1Widget(),
      Enrollment.routeName: (BuildContext context) => Enrollment(), 
      ScoreBoard.routeName: (BuildContext context) => ScoreBoard(),
      Bulletin.routeName: (BuildContext context) => Bulletin(),
      Login.routeName: (BuildContext context) => Login(),
      Settings.routeName: (BuildContext context) => Settings(),
      Ranking.routeName: (BuildContext context) => Ranking(),
      TournamentCalendar.routeName: (BuildContext context) => TournamentCalendar()
    },
  ));
}
