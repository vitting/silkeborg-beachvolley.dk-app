import 'dart:async';
import 'dart:collection';

import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_widget.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_match_data.dart';

class RankingDetailChartPointsWeek extends StatelessWidget {
  final String playerId;
  final Future<List<RankingMatchData>> getMatches;
  final double width;
  final double height;

  const RankingDetailChartPointsWeek(
      {Key key, this.playerId, this.getMatches, this.height, this.width})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: _loadMatches(),
        builder: (BuildContext context,
            AsyncSnapshot<List<Series<StatPointsOnWeek, String>>> snapshot) {
          if (!snapshot.hasData) return LoaderSpinner();
          if (snapshot.hasData && snapshot.data.length == 0) return Container();

          return Column(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: 20.0, bottom: 5.0),
                  width: width,
                  height: height,
                  child: BarChart(snapshot.data, animate: true)),
              Text(FlutterI18n.translate(context,
                  "ranking.rankingDetailChartPointsWeekWidget.string1"))
            ],
          );
        },
      ),
    );
  }

  Future<List<Series<StatPointsOnWeek, String>>> _loadMatches() async {
    SplayTreeMap<int, int> matchOnWeekNumber = SplayTreeMap<int, int>();
    List<RankingMatchData> matches = await getMatches;
    if (matches.length == 0) return [];

    matches.forEach((RankingMatchData match) {
      int weekNumber = DateTimeHelpers.weekInYear(match.matchDate);
      int points = 0;
      if (match.winner1.id == playerId) {
        points = match.winner1.points;
      } else if (match.winner2.id == playerId) {
        points = match.winner2.points;
      } else if (match.loser1.id == playerId) {
        points = match.loser1.points;
      } else if (match.loser2.id == playerId) {
        points = match.loser2.points;
      }

      matchOnWeekNumber.update(weekNumber, (int value) => value += points,
          ifAbsent: () => points);
    });

    List<StatPointsOnWeek> data = [];
    matchOnWeekNumber.forEach((int key, int value) {
      data.add(StatPointsOnWeek(key.toString(), value));
    });

    Series<StatPointsOnWeek, String> serie = Series<StatPointsOnWeek, String>(
        data: data,
        id: "weekstat",
        domainFn: (StatPointsOnWeek week, _) => week.weeknumber,
        measureFn: (StatPointsOnWeek week, _) => week.points,
        colorFn: (_, __) => MaterialPalette.blue.shadeDefault);

    return [serie];
  }
}

class StatPointsOnWeek {
  final String weeknumber;
  final int points;

  StatPointsOnWeek(this.weeknumber, this.points);
}
