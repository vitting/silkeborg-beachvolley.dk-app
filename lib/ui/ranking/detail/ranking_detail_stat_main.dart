import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/ranking/detail/ranking_detail_stat_row.dart';
import 'package:silkeborgbeachvolley/ui/ranking/detail/ranking_detail_stat_title.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_data.dart';

class RankingDetailStat extends StatelessWidget {
  final RankingPlayerData player;

  const RankingDetailStat({Key key, this.player}) : super(key: key);
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
                  title: "Point",
                  total: player.points.total,
                  won: player.points.won,
                  lost: player.points.lost
                ),
                RankingDetailStatRow(
                  title: "Spillede kampe",
                  total: player.numberOfPlayedMatches.total,
                  won: player.numberOfPlayedMatches.won,
                  lost: player.numberOfPlayedMatches.lost
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
