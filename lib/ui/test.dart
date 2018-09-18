import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;
import 'package:charts_flutter/flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/loader_spinner.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_firestore.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_match_data.dart';

class TestWidget extends StatefulWidget {
  @override
  TestWidgetState createState() {
    return new TestWidgetState();
  }
}

class TestWidgetState extends State<TestWidget> {
  Future<List<Series<StatMatchOnWeek, String>>> _loadMatches() async {
    SplayTreeMap<int, int> matchOnWeekNumber = SplayTreeMap<int, int>();
    List<DocumentSnapshot> snapshots =
        await RankingFirestore.getPlayerMatches("bpxa64leuva3kh8FA7EzQbDBIfr1");

    snapshots.forEach((DocumentSnapshot snapshot) {
      RankingMatchData match = RankingMatchData.fromMap(snapshot.data);
      int weekNumber = DateTimeHelpers.weekInYear(match.matchDate);
      matchOnWeekNumber.update(weekNumber, (int value) => ++value,
          ifAbsent: () => 1);
    });

    List<StatMatchOnWeek> data = [];
    matchOnWeekNumber.forEach((int key, int value) {
      data.add(StatMatchOnWeek(key.toString(), value));
    });

    Series<StatMatchOnWeek, String> serie = Series<StatMatchOnWeek, String>(
        data: data,
        id: "weekstat",
        domainFn: (StatMatchOnWeek week, _) => week.weeknumber,
        measureFn: (StatMatchOnWeek week, _) => week.played,
        colorFn: (_, __) => MaterialPalette.blue.shadeDefault);

    return [serie];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: _loadMatches(),
        builder: (BuildContext context,
            AsyncSnapshot<List<Series<StatMatchOnWeek, String>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData)
            return Container();
            
            return Container(
              child: BarChart(
                snapshot.data,
                animate: true,
                
              ),
            );
        },
      ),
    );
  }
}

class StatMatchOnWeek {
  final String weeknumber;
  final int played;

  StatMatchOnWeek(this.weeknumber, this.played);
}
