import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/helpers/dialogs_class.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_widget.dart';
import 'package:silkeborgbeachvolley/ui/helpers/no_data_widget.dart';
import 'package:silkeborgbeachvolley/ui/ranking/admin/helpers/admin_ranking_players_player_info_widget.dart';
import 'package:silkeborgbeachvolley/ui/ranking/admin/helpers/admin_ranking_players_row_widget.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_data_class.dart';

class AdminRankingPlayers extends StatefulWidget {
  final bool showDeletedPlayers;

  const AdminRankingPlayers({Key key, @required this.showDeletedPlayers})
      : super(key: key);

  @override
  _AdminRankingPlayersState createState() => _AdminRankingPlayersState();
}

class _AdminRankingPlayersState extends State<AdminRankingPlayers> {
  final ScrollController _scrollController = ScrollController();
  final _defaultNumberOfItemsToLoad = 50;
  int _numberOfItemsToLoad;
  int _currentLengthOfLoadedItems = 0;

  @override
  void initState() {
    super.initState();
    _numberOfItemsToLoad = _defaultNumberOfItemsToLoad;
    _scrollController.addListener(_handleScrollLoadMore);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: RankingPlayerData.getPlayersAsStream(widget.showDeletedPlayers, _numberOfItemsToLoad),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print("ERROR admin_ranking_players_main StreamBuilder: ${snapshot.error}");
          return Container();
        }
        if (!snapshot.hasData) return LoaderSpinner();
        if (snapshot.hasData && snapshot.data.documents.length == 0) {
          return NoData(FlutterI18n.translate(context, "ranking.adminRankingPlayersMain.string1"));
        }
          
        _currentLengthOfLoadedItems = snapshot.data.documents.length;
        return Scrollbar(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int position) {
              DocumentSnapshot doc = snapshot.data.documents[position];
              RankingPlayerData player = RankingPlayerData.fromMap(doc.data);
              return AdminRankingPlayersRow(
                name: player.name,
                photoUrl: player.photoUrl,
                rowOnTap: (bool value) {
                  rowOnTap(context, player);
                },
                rowOnMenuTap: (bool value) {
                  rowOnMenuTap(context, player);
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<void> rowOnMenuTap(
      BuildContext context, RankingPlayerData player) async {
    DialogsModalBottomSheetItem item = DialogsModalBottomSheetItem(
        FlutterI18n.translate(
            context, "ranking.adminRankingPlayersMain.string2"),
        FontAwesomeIcons.eyeSlash,
        0);
    if (widget.showDeletedPlayers) {
      item = DialogsModalBottomSheetItem(
          FlutterI18n.translate(
              context, "ranking.adminRankingPlayersMain.string3"),
          FontAwesomeIcons.eye,
          0);
    }

    int result = await Dialogs.modalBottomSheet(context, [item]);

    ConfirmDialogAction action;
    if (result != null && result == 0) {
      if (widget.showDeletedPlayers) {
        action = await Dialogs.confirmUnHide(
            context,
            FlutterI18n.translate(
                context, "ranking.adminRankingPlayersMain.string4"));
      } else {
        action = await Dialogs.confirmHide(
            context,
            FlutterI18n.translate(
                context, "ranking.adminRankingPlayersMain.string5"));
      }

      if (action != null && action == ConfirmDialogAction.unhide) {
        await player.unhide();
      }

      if (action != null && action == ConfirmDialogAction.hide) {
        await player.hide();
      }
    }
  }

  Future<void> rowOnTap(BuildContext context, RankingPlayerData player) async {
    await showDialog(
        context: context,
        builder: (BuildContext contextModal) {
          return AdminRankingPlayersPlayerInfo(
            player: player,
          );
        });
  }

  void _handleScrollLoadMore() {
    if (_scrollController.position.extentAfter == 0) {
      if (_currentLengthOfLoadedItems >= _numberOfItemsToLoad)
        setState(() {
          _numberOfItemsToLoad =
              _numberOfItemsToLoad + _defaultNumberOfItemsToLoad;
        });
    }
  }
}
