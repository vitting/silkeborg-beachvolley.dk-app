import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_theme.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_overlay_widget.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/createMatch/helpers/choose_players_list_widget.dart';
import 'package:silkeborgbeachvolley/ui/ranking/createMatch/helpers/create_player_choose_date_widget.dart';
import 'package:silkeborgbeachvolley/ui/ranking/createMatch/helpers/create_player_chooser_widget.dart';
import 'package:silkeborgbeachvolley/ui/ranking/createMatch/helpers/create_player_chooser_row_widget.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_firestore.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_match_data.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_match_player_data_class.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_data_class.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

class RankingCreateMatch extends StatefulWidget {
  @override
  _RankingCreateMatchState createState() => _RankingCreateMatchState();
}

class _RankingCreateMatchState extends State<RankingCreateMatch> {
  static final Color _okColor = Colors.blueAccent;
  static final Color _errorColor = Colors.redAccent;
  DateTime _matchDate;
  Color _matchDateColor = _okColor;
  Color _winner1Color = _okColor;
  Color _winner2Color = _okColor;
  Color _loser1Color = _okColor;
  Color _loser2Color = _okColor;
  RankingPlayerData _winner1Item;
  RankingPlayerData _winner2Item;
  RankingPlayerData _loser1Item;
  RankingPlayerData _loser2Item;
  String _noPlayerChoosenText = "";
  RankingPlayerData _loggedInPlayer;
  List<RankingPlayerData> _listOfPlayers = [];
  List<RankingPlayerData> _listOfFavoritePlayers = [];
  bool _saving = false;

  @override
  void initState() {
    _getPlayers();
    super.initState();
  }

  void _getPlayers() async {
    List<dynamic> playerFavorites = [];

    DocumentSnapshot doc =
        await RankingFirestore.getPlayer(Home.loggedInUser.uid);
    QuerySnapshot snapshot = await RankingFirestore.getAllPlayers();

    if (doc.exists) {
      _loggedInPlayer = RankingPlayerData.fromMap(doc.data);
      playerFavorites = _loggedInPlayer.playerFavorites.toList();
    }

    if (snapshot.documents.length > 0) {
      for (DocumentSnapshot p in snapshot.documents) {
        RankingPlayerData player = RankingPlayerData.fromMap(p.data);

        ///We adding ourself to favorites
        if (player.userId == _loggedInPlayer.userId) {
          _listOfFavoritePlayers.add(player);
          continue;
        }

        ///Adding loggin favoritusers to faveroites
        bool found = false;
        for (var favoriteId in playerFavorites) {
          if (favoriteId == player.userId) {
            _listOfFavoritePlayers.add(player);
            playerFavorites.remove(favoriteId);
            found = true;
            break;
          }
        }

        if (found) continue;

        _listOfPlayers.add(player);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _noPlayerChoosenText = FlutterI18n.translate(context, "ranking.rankingCreateMatchMain.string1");
    return SilkeborgBeachvolleyScaffold(
        title: FlutterI18n.translate(context, "ranking.rankingCreateMatchMain.string2"),
        body: LoaderSpinnerOverlay(
          show: _saving,
          text: FlutterI18n.translate(context, "ranking.rankingCreateMatchMain.string3"),
          child: Builder(builder: (BuildContext context) {
            return Card(
                child: ListView(
              children: <Widget>[
                CreatePlayerChooserRow(
                  chooser1Color: _winner1Color,
                  chooser2Color: _winner2Color,
                  chooser1Type: PlayerChooserType.winner1,
                  chooser2Type: PlayerChooserType.winner2,
                  player1Item: _winner1Item,
                  player2Item: _winner2Item,
                  noChoosenText: _noPlayerChoosenText,
                  title: FlutterI18n.translate(context, "ranking.rankingCreateMatchMain.string4"),
                  chooserOnTap: (PlayerChooserType type) {
                    _showPlayers(context, type);
                  },
                ),
                CreatePlayerChooserRow(
                  chooser1Color: _loser1Color,
                  chooser2Color: _loser2Color,
                  chooser1Type: PlayerChooserType.loser1,
                  chooser2Type: PlayerChooserType.loser2,
                  player1Item: _loser1Item,
                  player2Item: _loser2Item,
                  noChoosenText: _noPlayerChoosenText,
                  title: FlutterI18n.translate(context, "ranking.rankingCreateMatchMain.string5"),
                  chooserOnTap: (PlayerChooserType type) {
                    _showPlayers(context, type);
                  },
                ),
                CreatePlayerChooseDate(
                  color: _matchDateColor,
                  datePicked: (DateTime datePicked) {
                    setState(() {
                      _matchDate = datePicked;
                      _matchDateColor = _okColor;
                    });
                  },
                ),
                _saveButton(context)
              ],
            ));
          }),
        ));
  }

  Widget _saveButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: FlatButton.icon(
            textColor: SilkeborgBeachvolleyTheme.buttonTextColor,
            label: Text(FlutterI18n.translate(context, "ranking.rankingCreateMatchMain.string6")),
            icon: Icon(Icons.check_circle),
            onPressed: () {
              _saveMatch(context);
            },
          ),
        )
      ],
    );
  }

  _showPlayers(BuildContext context, PlayerChooserType type) async {
    RankingPlayerData player = await showDialog<RankingPlayerData>(
        context: context,
        builder: (BuildContext context) {
          return ChoosePlayersList(
            listOfFavoritePlayers: _listOfFavoritePlayers,
            listOfPlayers: _listOfPlayers,
            type: type,
            winner1Item: _winner1Item,
            winner2Item: _winner2Item,
            loser1Item: _loser1Item,
            loser2Item: _loser2Item,
          );
        });

    _updateChoosenPlayerState(player, type);
  }

  void _updateChoosenPlayerState(
      RankingPlayerData player, PlayerChooserType type) {
    if (player != null) {
      switch (type) {
        case PlayerChooserType.winner1:
          setState(() {
            _winner1Item = player;
          });
          break;
        case PlayerChooserType.winner2:
          setState(() {
            _winner2Item = player;
          });
          break;
        case PlayerChooserType.loser1:
          setState(() {
            _loser1Item = player;
          });
          break;
        case PlayerChooserType.loser2:
          setState(() {
            _loser2Item = player;
          });
          break;
        default:
          return null;
      }
    }
  }

  _saveMatch(BuildContext context) async {
    if (_isMatchValid()) {
      RankingMatchData match = RankingMatchData(
          matchDate: _matchDate,
          winner1: RankingMatchPlayerData(
              id: _winner1Item.userId,
              name: _winner1Item.name,
              photoUrl: _winner1Item.photoUrl,
              points: 0),
          winner2: RankingMatchPlayerData(
              id: _winner2Item.userId,
              name: _winner2Item.name,
              photoUrl: _winner2Item.photoUrl,
              points: 0),
          loser1: RankingMatchPlayerData(
              id: _loser1Item.userId,
              name: _loser1Item.name,
              photoUrl: _loser1Item.photoUrl,
              points: 0),
          loser2: RankingMatchPlayerData(
              id: _loser2Item.userId,
              name: _loser2Item.name,
              photoUrl: _loser2Item.photoUrl,
              points: 0));
      if (mounted) {
        setState(() {
          _saving = true;
        });
      }
      await match.save();
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
      Navigator.of(context).pop();
    } else {
      setState(() {});
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
            FlutterI18n.translate(context, "ranking.rankingCreateMatchMain.string7")),
        duration: Duration(seconds: 3),
      ));
    }
  }

  bool _isMatchValid() {
    bool isValid = true;
    if (_winner1Item == null) {
      _winner1Color = _errorColor;
      isValid = false;
    }
    if (_winner2Item == null) {
      _winner2Color = _errorColor;
      isValid = false;
    }
    if (_loser1Item == null) {
      _loser1Color = _errorColor;
      isValid = false;
    }
    if (_loser2Item == null) {
      _loser2Color = _errorColor;
      isValid = false;
    }
    if (_matchDate == null) {
      _matchDateColor = _errorColor;
      isValid = false;
    }

    return isValid;
  }
}
