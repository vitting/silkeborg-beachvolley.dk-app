import 'dart:async';
import 'dart:collection';

import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/loader_spinner_widget.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_match_data.dart';

class RankingDetailChartMatchesWeek extends StatefulWidget {
  final Future<List<RankingMatchData>> getMatches;
  final double width;
  final double height;

  const RankingDetailChartMatchesWeek({Key key, this.getMatches, this.height, this.width})
      : super(key: key);
  @override
  _RankingDetailChartMatchesWeekState createState() => _RankingDetailChartMatchesWeekState();
}

class _RankingDetailChartMatchesWeekState extends State<RankingDetailChartMatchesWeek> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: _loadMatches(),
        builder: (BuildContext context,
            AsyncSnapshot<List<Series<StatMatchOnWeek, String>>> snapshot) {
          if (!snapshot.hasData) return LoaderSpinner();
          if (snapshot.hasData && snapshot.data.length == 0) return Container();

          return Column(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: 20.0, bottom: 5.0),
                  width: widget.width,
                  height: widget.height,
                  child: BarChart(snapshot.data, animate: true)),
              Text("Antal spillede kampe pr. uge")
            ],
          );
        },
      ),
    );
  }

  Future<List<Series<StatMatchOnWeek, String>>> _loadMatches() async {
    SplayTreeMap<int, int> matchOnWeekNumber = SplayTreeMap<int, int>();
    List<RankingMatchData> matches = await widget.getMatches;
    if (matches.length == 0) return [];

    matches.forEach((RankingMatchData match) {
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
}

class StatMatchOnWeek {
  final String weeknumber;
  final int played;

  StatMatchOnWeek(this.weeknumber, this.played);
}
