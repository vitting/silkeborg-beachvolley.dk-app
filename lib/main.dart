import 'package:flutter/material.dart';
// import 'package:silkeborgbeachvolley/ui/home/home.dart';
import 'package:silkeborgbeachvolley/ui/home/news_detail_item.dart';
import 'package:silkeborgbeachvolley/ui/home/testdata.dart';
// import 'package:silkeborgbeachvolley/ui/enrollment/enrollment_main.dart';
// import 'package:silkeborgbeachvolley/ui/login/login_main.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
// import 'package:silkeborgbeachvolley/ui/scoreboard/scoreboard_main.dart';

void main() {
  runApp(new MaterialApp(
    title: 'Silkeborg Beachvolley',
    home: SilkeborgBeachvolleyScaffold(
      title: "Silkeborg Beachvolley",
      body: NewsDetailItem(data[0])
    )
  ));
}
