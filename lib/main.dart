import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
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
import 'package:silkeborgbeachvolley/ui/scoreboard/scoreboard_main.dart';
import 'package:silkeborgbeachvolley/ui/settings/settings_main.dart';
import 'package:silkeborgbeachvolley/ui/test.dart';
import 'package:silkeborgbeachvolley/ui/tournament_calendar/main/tournament_calendar_main.dart';

void main() async {
  /// Set firestore to save and return dates as Timestamp
  final FirebaseApp app = FirebaseApp(name: "[DEFAULT]");
  final Firestore firestore = Firestore(app: app);
  await firestore.settings(timestampsInSnapshotsEnabled: true);

  runApp(MaterialApp(
    title: 'Silkeborg Beachvolley',
    locale: const Locale("da"),
    supportedLocales: [const Locale("da")],
    localizationsDelegates: [
      FlutterI18nDelegate(false, "da"),
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
      ScoreBoard.routeName: (BuildContext context) => ScoreBoard(),
      Bulletin.routeName: (BuildContext context) => Bulletin(),
      Login.routeName: (BuildContext context) => Login(),
      Settings.routeName: (BuildContext context) => Settings(),
      Ranking.routeName: (BuildContext context) => Ranking(),
      AdminRanking.routeName: (BuildContext context) => AdminRanking(),
      TournamentCalendar.routeName: (BuildContext context) =>
          TournamentCalendar()
    },
  ));
}
