import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/main/bulletin_main.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/admin/admin_enrollment_main.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/main/enrollment_main.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/login/login_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/admin/admin_ranking_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/main/ranking_main.dart';
import 'package:silkeborgbeachvolley/ui/livescore/main/livescore_main.dart';
import 'package:silkeborgbeachvolley/ui/settings/settings_main.dart';
import 'package:silkeborgbeachvolley/ui/tournament_calendar/main/tournament_calendar_main.dart';
import 'package:silkeborgbeachvolley/ui/users/admin/admin_users_main.dart';

class MainMaterialApp extends StatefulWidget {
  @override
  _MainMaterialAppState createState() => _MainMaterialAppState();
}

class _MainMaterialAppState extends State<MainMaterialApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showPerformanceOverlay: false,
      title: "Silkeborg Beachvolley",
      localizationsDelegates: [
        FlutterI18nDelegate(false, "en"),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      theme: ThemeData(
          // primaryColor: Colors.yellow
          ),
      initialRoute: "/",
      routes: <String, WidgetBuilder>{
        "/": (BuildContext context) => Home(),
        // "/": (BuildContext context) => TestWidget(),
        Enrollment.routeName: (BuildContext context) => Enrollment(),
        AdminEnrollment.routeName: (BuildContext context) => AdminEnrollment(),
        Livescore.routeName: (BuildContext context) => Livescore(),
        Bulletin.routeName: (BuildContext context) => Bulletin(),
        Login.routeName: (BuildContext context) => Login(),
        Settings.routeName: (BuildContext context) => Settings(),
        Ranking.routeName: (BuildContext context) => Ranking(),
        AdminRanking.routeName: (BuildContext context) => AdminRanking(),
        AdminUsers.routeName: (BuildContext context) => AdminUsers(),
        TournamentCalendar.routeName: (BuildContext context) =>
            TournamentCalendar()
      },
    );
  }
}