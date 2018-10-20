import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/helpers/confirm_dialog_action_enum.dart';
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
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: RankingPlayerData.getPlayersAsStream(widget.showDeletedPlayers),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print(
              "ERROR admin_ranking_players_main StreamBuilder: ${snapshot.error}");
          return Container();
        }
        if (!snapshot.hasData) return LoaderSpinner();
        if (snapshot.hasData && snapshot.data.documents.length == 0)
          return NoData("Der blev ikke fundet nogen spillere");
        return Container(
          child: ListView.builder(
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
    DialogsModalBottomSheetItem item =
        DialogsModalBottomSheetItem("Skjul", FontAwesomeIcons.eyeSlash, 0);
    if (widget.showDeletedPlayers) {
      item = DialogsModalBottomSheetItem("Vis", FontAwesomeIcons.eye, 0);
    }

    int result = await Dialogs.modalBottomSheet(context, [item]);

    ConfirmDialogAction action;
    if (result != null && result == 0) {
      if (widget.showDeletedPlayers) {
        action = await Dialogs.confirmUnHide(
            context, "Er du sikker på du Vil vise spilleren?");
      } else {
        action = await Dialogs.confirmHide(context,
            "Er du sikker på du Vil skjule spilleren? \nSpilleren kan vises igen ved at vælge spilleren i menuen skjulte spillere");
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
}
