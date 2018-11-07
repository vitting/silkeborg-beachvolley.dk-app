import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/ui/helpers/dot_bottombar_widget.dart';
import 'package:silkeborgbeachvolley/ui/ranking/detail/ranking_detail_matches_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/detail/ranking_detail_stat_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_firestore.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_match_data.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_data_class.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

class RankingDetail extends StatefulWidget {
  final RankingPlayerData player;
  const RankingDetail(this.player);

  @override
  RankingDetailState createState() {
    return new RankingDetailState();
  }
}

class RankingDetailState extends State<RankingDetail> {
  List<RankingMatchData> _cachedMatches;
  int _position = 0;
  String _title;
  List<Widget> _widgets = [];
  PageController _controller = PageController();
  @override
  void initState() {
    super.initState();
    _initPages();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initPages() async {
    _widgets = [
      RankingDetailStat(
        player: widget.player,
        matches: _loadMatches(),
      ),
      RankingDetailMatches(
          matches: _loadMatches(), userId: widget.player.userId)
    ];
  }

  @override
  Widget build(BuildContext context) {
    _title = _getPageTitle(context, _position);
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
          onPageChanged: (int page) {
            setState(() {
              _position = page;
              _title = _getPageTitle(context, page);
            });
          },
        ));
  }

  String _getPageTitle(BuildContext context, int page) {
    String title = "";
    if (page == 0)
      title =
          FlutterI18n.translate(context, "ranking.rankingDetailMain.title1");
    if (page == 1)
      title =
          FlutterI18n.translate(context, "ranking.rankingDetailMain.title2");
    return title;
  }

  Future<List<RankingMatchData>> _loadMatches() async {
    if (_cachedMatches != null) return _cachedMatches;

    List<DocumentSnapshot> list =
        await RankingFirestore.getPlayerMatches(widget.player.userId);
    List<RankingMatchData> matches = list.map((DocumentSnapshot doc) {
      return RankingMatchData.fromMap(doc.data);
    }).toList();

    matches.sort((RankingMatchData a, RankingMatchData b) =>
        a.matchDate.compareTo(b.matchDate));

    _cachedMatches = matches;
    return matches;
  }
}
