import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/createMatch/helpers/choose_players_list_row_widget.dart';
import 'package:silkeborgbeachvolley/ui/ranking/createMatch/helpers/create_player_chooser_widget.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_firestore.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_data_class.dart';

class ChoosePlayersList extends StatefulWidget {
  final RankingPlayerData winner1Item;
  final RankingPlayerData winner2Item;
  final RankingPlayerData loser1Item;
  final RankingPlayerData loser2Item;
  final PlayerChooserType type;
  final List<RankingPlayerData> listOfPlayers;
  final List<RankingPlayerData> listOfFavoritePlayers;
  const ChoosePlayersList(
      {Key key,
      @required this.listOfPlayers,
      @required this.type,
      @required this.winner1Item,
      @required this.winner2Item,
      @required this.loser1Item,
      @required this.loser2Item,
      @required this.listOfFavoritePlayers})
      : super(key: key);
  @override
  _ChoosePlayersListState createState() => _ChoosePlayersListState();
}

class _ChoosePlayersListState extends State<ChoosePlayersList> {
  List<Widget> _playerListWidgets = [];
  List<Widget> _playerFavoriteListWidgets = [];

  @override
  void initState() {
    _generatePlayerWidgets();
    super.initState();
  }

  _generatePlayerWidgets() {
    setState(() {
      _playerFavoriteListWidgets = _generatePlayerFavoritesList();
      _playerListWidgets = _generatePlayerList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        title: Text(_getDialogTitle(context, widget.type)),
        children: <Widget>[
          ListBody(
            children: _playerFavoriteListWidgets,
          ),
          Divider(),
          ListBody(
            children: _playerListWidgets,
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

  List<Widget> _generatePlayerFavoritesList() {
    List<Widget> favorites =
        widget.listOfFavoritePlayers.map<Widget>((RankingPlayerData player) {
      return _generatePlayerListTile(player, true);
    }).toList();

    return favorites;
  }

  List<Widget> _generatePlayerList() {
    List<Widget> players =
        widget.listOfPlayers.map<Widget>((RankingPlayerData player) {
      return _generatePlayerListTile(player, false);
    }).toList();

    return players;
  }

  Widget _generatePlayerListTile(RankingPlayerData player, bool favorite) {
    return ChoosePlayerListRow(
        isFavorite: favorite,
        isPlayerSelected: _isPlayerSelected(player),
        player: player,
        onTap: (_) {
          if (!_isPlayerSelected(player))
            Navigator.of(context).pop<RankingPlayerData>(player);
        },
        onLongPress: (bool isFavoerite) {
          if (isFavoerite) {
            RankingFirestore.removePlayerAsFavorite(
                Home.loggedInUser.uid, player.userId);
            widget.listOfFavoritePlayers.remove(player);

            widget.listOfPlayers.add(player);
            widget.listOfPlayers
                .sort((RankingPlayerData item1, RankingPlayerData item2) {
              return item1.name.compareTo(item2.name);
            });
          } else {
            RankingFirestore.addPlayerAsFavorite(
                Home.loggedInUser.uid, player.userId);
            widget.listOfPlayers.remove(player);

            widget.listOfFavoritePlayers.add(player);
            widget.listOfFavoritePlayers
                .sort((RankingPlayerData item1, RankingPlayerData item2) {
              return item1.name.compareTo(item2.name);
            });
          }
          _generatePlayerWidgets();
        });
  }

  String _getDialogTitle(BuildContext context, PlayerChooserType type) {
    if (type == PlayerChooserType.winner1 || type == PlayerChooserType.winner2)
      return FlutterI18n.translate(context, "ranking.choosePlayersListWidget.string1");
    if (type == PlayerChooserType.loser1 || type == PlayerChooserType.loser2)
      return FlutterI18n.translate(context, "ranking.choosePlayersListWidget.string2");
    return "";
  }
}
