import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_theme.dart';
import 'package:silkeborgbeachvolley/ui/helpers/dot_bottombar_widget.dart';
import 'package:silkeborgbeachvolley/ui/ranking/createMatch/ranking_create_match_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_sharedpref.dart';
import 'package:silkeborgbeachvolley/ui/ranking/main/first_time/ranking_firsttime_main.dart';
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
  List<Widget> _pages = [];
  PageController _controller = PageController();

  @override
  void initState() {
    super.initState();
    _initPages();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _checkIfPlayerExists(context));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initPages() async {
    _pages = [RankingList(), RankingMatches()];
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        title: _getPageTitle(context, _position),
        bottomNavigationBar: DotBottomBar(
          numberOfDot: 2,
          position: _position,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: SilkeborgBeachvolleyTheme.buttonTextColor,
          tooltip: FlutterI18n.translate(context, "ranking.rankingMain.string1"),
          onPressed: () async {
            await Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => RankingCreateMatch(),
                fullscreenDialog: true));
          },
          child: Icon(Icons.add),
        ),
        body: PageView.builder(
          itemCount: _pages.length,
          controller: _controller,
          itemBuilder: (BuildContext context, int page) {
            return _pages[page];
          },
          onPageChanged: (int page) {
            setState(() {
              _position = page;
            });
          },
        ));
  }

  String _getPageTitle(BuildContext context, int page) {
    String title = "";
    if (page == 0) title = FlutterI18n.translate(context, "ranking.rankingMain.title1");
    if (page == 1) title = FlutterI18n.translate(context, "ranking.rankingMain.title2");
    return title;
  }

  void _checkIfPlayerExists(BuildContext context) async {
    if (await RankingSharedPref.isItfirstTime()) {
      _showFirstTimeSetup(context);
    }
  }

  _showFirstTimeSetup(BuildContext context) async {
    await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              RankingFirstTime(
                onPressedValue: (bool value) async {
                  if (value) {
                    await RankingSharedPref.setIsItFirsttime(false);
                  }
                },
              )
            ],
          );
        });
  }
}
