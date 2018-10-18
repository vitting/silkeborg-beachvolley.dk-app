import 'package:flutter/material.dart';
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
  List<Widget> _widgets = [];
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
    _widgets = [
      RankingList(),
      RankingMatches()
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepOrange[700],
          tooltip: "Registere kamp",
          onPressed: () async {
            await Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => RankingCreateMatch(),
                fullscreenDialog: true));
          },
          child: Icon(Icons.add),
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
    if (page == 0) title = "Ranglisten";
    if (page == 1) title = "De sidste 10 spillede kampe";
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
