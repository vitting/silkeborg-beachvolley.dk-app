import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/ranking/detail/ranking_detail_matches_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/detail/ranking_detail_stat_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_data.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'package:dots_indicator/dots_indicator.dart';

//CHRISTIAN: Antal point, total, won, lost + number of playerdmatchtes total, won, lost
//Hent kampe for den sidste måned eller hele sæsonen.
//Måske en graf med antal spillede kampe/point/vundne/tabte på dage i den sidste måned.

class RankingDetail extends StatefulWidget {
  final RankingPlayerData player;
  RankingDetail(this.player);

  @override
  RankingDetailState createState() {
    return new RankingDetailState();
  }
}

class RankingDetailState extends State<RankingDetail> {
  int _position = 0;
  String _title;

  @override
    void initState() {
      super.initState();
      _title = _getPageTitle(_position);
    }
  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        title: _title,
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0, top: 5.0),
              child: DotsIndicator(
                numberOfDot: 2,
                position: _position,
              ),
            )
          ],
        ),
        body: PageView(
          onPageChanged: (int page) {
            _position = page;
            _title = _getPageTitle(page);
            setState(() {
              
            });
          },
          children: <Widget>[
            RankingDetailStat(
              player: widget.player,
            ),
            RankingDetailMatches(userId: widget.player.userId)
          ],
        ));
  }

  _getPageTitle(int page) {
    if (page == 0) return "Spiller statestik";
    if (page == 1) return "Spillede kampe";
  }
}
