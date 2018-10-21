import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/confirm_dialog_action_enum.dart';
import 'package:silkeborgbeachvolley/helpers/dialogs_class.dart';
import 'package:silkeborgbeachvolley/helpers/firebase_functions_call.dart';
import 'package:silkeborgbeachvolley/ui/helpers/dot_bottombar_widget.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_overlay_widget.dart';
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
  bool _showLoader = false;
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
        title: _getPageTitle(context, _position),
        actions: _position == 0 ? _actionMenu() : null,
        bottomNavigationBar: DotBottomBar(
          numberOfDot: _numberOfPages,
          position: _position,
        ),
        body: LoaderSpinnerOverlay(
          show: _showLoader,
          text: FlutterI18n.translate(context, "ranking.adminRankingMain.string1"),
          child: PageView.builder(
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
          ),
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
                      ? Text(FlutterI18n.translate(context, "ranking.adminRankingMain.string2"))
                      : Text(FlutterI18n.translate(context, "ranking.adminRankingMain.string3")),
                ),
                PopupMenuItem(value: 1, child: Text(FlutterI18n.translate(context, "ranking.adminRankingMain.string4")))
              ]);

          if (result != null && result == 0) {
            setState(() {
              _showDeletedPlayers = !_showDeletedPlayers;
            });
          }

          if (result != null && result == 1) {
            await _resetSeason(context);
          }
        },
      ),
    ];
  }

  Future<void> _resetSeason(BuildContext context) async {
    ConfirmDialogAction result = await Dialogs.confirmReset(context,
        FlutterI18n.translate(context, "ranking.adminRankingMain.string5"));

    if (result != null && result == ConfirmDialogAction.reset) {
      setState(() {
        _showLoader = true;              
      });
      
      await FirebaseFunctions.resetRanking();
      
      setState(() {
        _showLoader = false;              
      });
    }
  }

  String _getPageTitle(BuildContext context, int page) {
    String title = "";
    if (page == 0 && _showDeletedPlayers == false)
      title = FlutterI18n.translate(context, "ranking.adminRankingMain.string6");
    if (page == 0 && _showDeletedPlayers)
      title = FlutterI18n.translate(context, "ranking.adminRankingMain.string7");
    if (page == 1) title = FlutterI18n.translate(context, "ranking.adminRankingMain.string8");
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
