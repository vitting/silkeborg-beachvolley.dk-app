import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/ranking/createMatch/choose_players_list_row.dart';
import 'package:silkeborgbeachvolley/ui/ranking/createMatch/create_player_chooser.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_data_class.dart';

class ChoosePlayersList extends StatefulWidget {
  final RankingPlayerData winner1Item;
  final RankingPlayerData winner2Item;
  final RankingPlayerData loser1Item;
  final RankingPlayerData loser2Item;
  final PlayerChooserType type;
  final List<RankingPlayerData> listOfPlayers;
  const ChoosePlayersList({Key key, @required this.listOfPlayers, @required this.type, @required this.winner1Item, @required this.winner2Item, @required this.loser1Item, @required this.loser2Item}) : super(key: key);
  @override
  _ChoosePlayersListState createState() => _ChoosePlayersListState();
}

class _ChoosePlayersListState extends State<ChoosePlayersList> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        title: Text(_getDialogTitle(widget.type)),
        children: <Widget>[
          ListBody(
            children: _generatePlayerList(),
          )
        ]);
  }

  bool _isPlayerSelected(RankingPlayerData player) {
    if (widget.winner1Item?.userId == player.userId ||
        widget.winner2Item?.userId == player.userId ||
        widget.loser1Item?.userId == player.userId ||
        widget.loser2Item?.userId == player.userId) return true;
    return false;
  }

  List<Widget> _generatePlayerList() {
    return  widget.listOfPlayers.map<Widget>((RankingPlayerData player) {
      return _generatePlayerListTile(player);
    }).toList();
  }

  Widget _generatePlayerListTile(RankingPlayerData player) {
    return ChoosePlayerListRow(
      isPlayerSelected: _isPlayerSelected(player),
      photoUrl: player.photoUrl,
      playerName: player.name,
      onTap: (_) {
        if (!_isPlayerSelected(player))
          Navigator.of(context).pop<RankingPlayerData>(player);
      },
    );
  }

  String _getDialogTitle(PlayerChooserType type) {
    if (type == PlayerChooserType.winner1 || type == PlayerChooserType.winner2)
      return "Vælg vinder";
    if (type == PlayerChooserType.loser1 || type == PlayerChooserType.loser2)
      return "Vælg taber";
    return "";
  }
}
