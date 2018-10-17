import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/confirm_dialog_action_enum.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/dialogs_class.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_match_data.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_data_class.dart';
import 'package:silkeborgbeachvolley/ui/ranking/main/list_of_matches/helpers/ranking_matches_row_element_widget.dart';

class RankingMatchesRow extends StatelessWidget {
  static Map<String, String> _cachedData =
      Map<String, String>();
  final RankingMatchData match;
  final String userId;

  const RankingMatchesRow(
      {Key key, @required this.match, @required this.userId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 3.0),
                child: Row(
                  children: <Widget>[
                    Tooltip(
                      message: "Kamp dato",
                      child: Icon(Icons.calendar_today,
                          size: 12.0, color: Colors.black),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(DateTimeHelpers.dMMyyyy(match.matchDate),
                          style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
              ),
              _menuIcon(context, match)
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      RankingMatchesRowElement(
                          name: match.winner1.name,
                          points: match.winner1.points,
                          photoUrl: match.winner1.photoUrl,
                          backgroundColor: Colors.blue[700]),
                      RankingMatchesRowElement(
                          name: match.winner2.name,
                          points: match.winner2.points,
                          photoUrl: match.winner2.photoUrl,
                          backgroundColor: Colors.blue[700])
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 3.0),
                  child: Column(
                    children: <Widget>[
                      RankingMatchesRowElement(
                          name: match.loser1.name,
                          points: match.loser1.points,
                          photoUrl: match.loser1.photoUrl,
                          backgroundColor: Colors.blue),
                      RankingMatchesRowElement(
                          name: match.loser2.name,
                          points: match.loser2.points,
                          photoUrl: match.loser2.photoUrl,
                          backgroundColor: Colors.blue)
                    ],
                  ),
                ),
              )
            ],
          ),
          _createdByPlayer()
        ],
      ),
    );
  }

  Widget _createdByPlayer() {
    Widget widgets;
    if (RankingMatchesRow._cachedData.containsKey(match.userId)) {
      String playerName = RankingMatchesRow._cachedData[match.userId];
      widgets = _createdByPlayerRow(playerName);
    } else {
      widgets = FutureBuilder(
        future: match.getPlayerCreatedMatch(),
        builder:
            (BuildContext context, AsyncSnapshot<RankingPlayerData> player) {
          if (!player.hasData) return Container();

          RankingMatchesRow._cachedData
              .putIfAbsent(match.userId, () => player.data.name);
          return _createdByPlayerRow(player.data.name);
        },
      );
    }

    return widgets;
  }

  Widget _createdByPlayerRow(String name) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text("Oprettet af $name",
              style: TextStyle(fontSize: 10.0, fontStyle: FontStyle.italic))
        ],
      ),
    );
  }

  Widget _menuIcon(BuildContext context, RankingMatchData match) {
    Widget icon = Container();
    if (userId == match.userId) {
      icon = IconButton(
        icon: Icon(Icons.more_horiz, color: Colors.deepOrange[700]),
        onPressed: () {
          _showDelete(context, match);
        },
      );
    }
    return icon;
  }

  Future<void> _showDelete(BuildContext context, RankingMatchData match) async {
    int result = await Dialogs.modalBottomSheet(
        context, [DialogsModalBottomSheetItem("Slet", Icons.delete, 0)]);

    if (result != null) {
      ConfirmDialogAction action = await Dialogs.confirmDelete(
          context, "Er du sikker på du vil slette kampen?");

      if (action != null && action == ConfirmDialogAction.delete) {
        match.delete();
      }
    }
  }
}
