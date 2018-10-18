import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/helpers/dot_bottombar_widget.dart';
import 'package:silkeborgbeachvolley/ui/ranking/admin/admin_ranking_matches_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/admin/admin_ranking_players_main.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

class AdminRanking extends StatefulWidget {
  static final String routeName = "/adminranking";
  @override
  AdminRankingState createState() {
    return new AdminRankingState();
  }
}

class AdminRankingState extends State<AdminRanking> {
  int _position = 0;
  bool _showDeletedPlayers = false;
  int _numberOfPages = 2;
  PageController _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        title: _getPageTitle(_position),
        actions: _position == 0 ? _actionMenu() : null,
        bottomNavigationBar: DotBottomBar(
          numberOfDot: _numberOfPages,
          position: _position,
        ),
        body: PageView.builder(
          itemCount: _numberOfPages,
          controller: _controller,
          itemBuilder: (BuildContext context, int page) {
            return _getPage(page);
          },
          onPageChanged: (int page) {
            setState(() {
              _position = page;
            });
          },
        ));
  }

  List<Widget> _actionMenu() {
    return [
      IconButton(
        icon: Icon(Icons.more_vert),
        onPressed: () async {
          int result = await showMenu<int>(
              position: RelativeRect.fromLTRB(0.0, 70.0, -10.0, 0.0),
              context: context,
              items: <PopupMenuEntry<int>>[
                PopupMenuItem(
                  value: 0,
                  child: _showDeletedPlayers
                      ? Text("Vis ikke slettede spillere")
                      : Text("Vis slettede spillere"),
                )
              ]);

          if (result != null && result == 0) {
            setState(() {
              _showDeletedPlayers = !_showDeletedPlayers;
            });
          }
        },
      ),
    ];
  }

  String _getPageTitle(int page) {
    String title = "";
    if (page == 0 && _showDeletedPlayers == false)
      title = "Administerer spillere";
    if (page == 0 && _showDeletedPlayers)
      title = "Administerer slettede spillere";
    if (page == 1) title = "Administerer kampe";
    return title;
  }

  Widget _getPage(int page) {
    Widget pageWidget;
    switch (page) {
      case 0:
        pageWidget =
            AdminRankingPlayers(showDeletedPlayers: _showDeletedPlayers);
        break;
      case 1:
        pageWidget = AdminRankingMatches();
        break;
      default:
    }

    return pageWidget;
  }
}
