import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/ui/ranking/detail/helpers/ranking_detail_charts_widget.dart';
import 'package:silkeborgbeachvolley/ui/ranking/detail/helpers/ranking_detail_stat_row_widget.dart';
import 'package:silkeborgbeachvolley/ui/ranking/detail/helpers/ranking_detail_stat_title_widget.dart';
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
                    title: FlutterI18n.translate(context, "ranking.rankingDetailStatMain.string1"),
                    total: player.points.total,
                    won: player.points.won,
                    lost: player.points.lost),
                RankingDetailStatRow(
                    title: FlutterI18n.translate(context, "ranking.rankingDetailStatMain.string2"),
                    total: player.numberOfPlayedMatches.total,
                    won: player.numberOfPlayedMatches.won,
                    lost: player.numberOfPlayedMatches.lost),
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints contraints) {
                    return RankingDetailCharts(
                      height: 200.0,
                      width: contraints.maxWidth,
                      player: player,
                      matches: matches,
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
