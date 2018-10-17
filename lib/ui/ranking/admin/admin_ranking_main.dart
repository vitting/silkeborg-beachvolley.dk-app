import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/helpers/dot_bottombar_widget.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_firestore.dart';
import 'package:silkeborgbeachvolley/ui/ranking/main/list_of_matches/ranking_matches_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/main/list_of_ranking/ranking_list_main.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

class Ranking extends StatefulWidget {
  static final String routeName = "/ranking";
  @override
  RankingState createState() {
    return new RankingState();
  }
}

class RankingState extends State<Ranking> {
  int _position = 0;
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
      RankingList(),
      RankingMatches(
        userId: Home.loggedInUser.uid,
        matches: RankingFirestore.getMatchesAsStream(10)
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        title: _getPageTitle(_position),
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
            });
          },
        ));
  }

  String _getPageTitle(int page) {
    String title = "";
    if (page == 0) title = "Administerer spillere";
    if (page == 1) title = "Administerer kampe";
    return title;
  }
}
