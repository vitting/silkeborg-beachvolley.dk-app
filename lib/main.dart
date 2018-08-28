import 'package:flutter/material.dart';
// import 'package:silkeborgbeachvolley/ui/home/create_news_main.dart';
import 'package:silkeborgbeachvolley/ui/home/news_main.dart';
import 'package:silkeborgbeachvolley/ui/test.dart';
// import 'package:silkeborgbeachvolley/ui/home/news_detail_item.dart';
// import 'package:silkeborgbeachvolley/ui/home/testdata.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/enrollment_main.dart';
// import 'package:silkeborgbeachvolley/ui/login/login_main.dart';
import 'package:silkeborgbeachvolley/ui/scoreboard/scoreboard_main.dart';

void main() {
  runApp(new MaterialApp(
    title: 'Silkeborg Beachvolley',
    initialRoute: "/",
    routes: <String, WidgetBuilder>{
      "/": (context) => TestWidget(),
      "/enrollment": (context) => Enrollment(),
      "/scoreboard": (context) => ScoreBoard()
    },
  ));
}
