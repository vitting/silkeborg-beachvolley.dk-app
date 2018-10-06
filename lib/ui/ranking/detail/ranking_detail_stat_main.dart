import 'dart:async';

import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/ranking/detail/ranking_detail_chart.dart';
// import 'package:charts_flutter/flutter.dart';
import 'package:silkeborgbeachvolley/ui/ranking/detail/ranking_detail_stat_row.dart';
import 'package:silkeborgbeachvolley/ui/ranking/detail/ranking_detail_stat_title.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_match_data.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_data_class.dart';

class RankingDetailStat extends StatelessWidget {
  final RankingPlayerData player;
  final Future<List<RankingMatchData>> matches;

  const RankingDetailStat({Key key, this.player, this.matches})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                RankingDetailStatTitle(
                  name: player.name,
                  photoUrl: player.photoUrl,
                ),
                RankingDetailStatRow(
                    title: "Points",
                    total: player.points.total,
                    won: player.points.won,
                    lost: player.points.lost),
                RankingDetailStatRow(
                    title: "Spillede kampe",
                    total: player.numberOfPlayedMatches.total,
                    won: player.numberOfPlayedMatches.won,
                    lost: player.numberOfPlayedMatches.lost),
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints contraints) {
                    return Column(
                      children: <Widget>[
                        RankingDetailChart(
                            getMatches: matches,
                            width: contraints.maxWidth - 50.0,
                            height: 200.0)
                      ],
                    );
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
