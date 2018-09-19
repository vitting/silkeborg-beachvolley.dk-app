import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/dot_bottombar.dart';
import 'package:silkeborgbeachvolley/ui/ranking/detail/ranking_detail_matches_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/detail/ranking_detail_stat_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_firestore.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_match_data.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_data.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

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
  List<Widget> _widgets = [];
  PageController _controller = PageController();
  @override
  void initState() {
    super.initState();
    _title = _getPageTitle(_position);
    _initPages();
  }

  void _initPages() async {
    _widgets = [
      RankingDetailStat(
        player: widget.player,
      ),
      RankingDetailMatches(matches: _loadMatches(), userId: widget.player.userId)
    ];
  }

  @override
  Widget build(BuildContext context) {
    
    return SilkeborgBeachvolleyScaffold(
        title: _title,
        bottomNavigationBar: DotBottomBar(
          numberOfDot: 2,
          position: _position,
        ),
        body: PageView.builder(
          itemCount: _widgets.length,
          controller: _controller,
          itemBuilder: (BuildContext context, int page) {
            return _widgets[page];
          },
          onPageChanged: (int page) async {
            _position = page;
            _title = _getPageTitle(page);
            setState(() {

            });
          },
        ));
  }

  String _getPageTitle(int page) {
    String title = "";
    if (page == 0) title = "Spiller statestik";
    if (page == 1) title = "Spillede kampe";
    return title;
  }

  Future<List<RankingMatchData>> _loadMatches() async {
    List<DocumentSnapshot> list =
          await RankingFirestore.getPlayerMatches(widget.player.userId);
      List<RankingMatchData> matches = list.map((DocumentSnapshot doc) {
        return RankingMatchData.fromMap(doc.data);
      }).toList();

      matches.sort((RankingMatchData a, RankingMatchData b) =>
          a.matchDate.compareTo(b.matchDate));

          return matches;
  }
}
