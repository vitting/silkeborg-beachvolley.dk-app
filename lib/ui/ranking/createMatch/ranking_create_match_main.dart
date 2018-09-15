import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/ui/ranking/createMatch/create_player_chooser.dart';
import 'package:silkeborgbeachvolley/ui/ranking/createMatch/create_player_chooser_row.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_firestore.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_data.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

class RankingCreateMatch extends StatefulWidget {
  @override
  _RankingCreateMatchState createState() => _RankingCreateMatchState();
}

class _RankingCreateMatchState extends State<RankingCreateMatch> {
  String _matchDate = "Vælg kamp dato";
  Color _matchDateColor = Colors.blueAccent;
  Color _winner1Color = Colors.blueAccent;
  Color _winner2Color = Colors.blueAccent;
  RankingPlayerData _winner1Item;
  RankingPlayerData _winner2Item;
  RankingPlayerData _loser1Item;
  RankingPlayerData _loser2Item;
  String _noPlayerChoosenText = "Ingen spiller valgt";
  List<RankingPlayerData> _listOfPlayers = [];

  @override
  void initState() {
    super.initState();
    _getPlayersList();
  }

  _getPlayersList() async {
    QuerySnapshot snapshot = await RankingFirestore.getAllPlayers();
    if (snapshot.documents.length > 0) {
      _listOfPlayers = snapshot.documents.map((DocumentSnapshot doc) {
        return RankingPlayerData.fromMap(doc.data);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
      title: "Registere kamp",
      body: Card(
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
            title: "Vindere",
            chooserOnTap: (PlayerChooserType type) {
              _showPlayers(context, type);
            },
          ),
          CreatePlayerChooserRow(
            chooser1Color: _winner2Color,
            chooser2Color: _winner2Color,
            chooser1Type: PlayerChooserType.loser1,
            chooser2Type: PlayerChooserType.loser2,
            player1Item: _loser1Item,
            player2Item: _loser2Item,
            noChoosenText: _noPlayerChoosenText,
            title: "Tabere",
            chooserOnTap: (PlayerChooserType type) {
              _showPlayers(context, type);
            },
          ),
          Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      _selectDate(context);
                    },
                    icon: Icon(
                      FontAwesomeIcons.calendarPlus,
                      size: 30.0,
                      color: _matchDateColor,
                    ),
                  ),
                  Text(_matchDate)
                ],
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  _saveMatch();
                },
                child: Text("Registere kampen"),
              )
            ],
          )
        ],
      )),
    );
  }

  _showPlayers(BuildContext context, PlayerChooserType type) async {
    List<Widget> widgets = _listOfPlayers.map<ListTile>((RankingPlayerData player) {
      return _generatePlayerListTile(player);
    }).toList();

    RankingPlayerData player = await showDialog<RankingPlayerData>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(_getDialogTitle(type)),
            children: widgets
          );
        });

    _updateChoosenPlayerState(player, type);
  }

  Widget _generatePlayerListTile(RankingPlayerData player) {
    return ListTile(
        onTap: () {
          if (!_isPlayerSelected(player)) Navigator.of(context).pop<RankingPlayerData>(player);
        },
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(player.photoUrl),
        ),
        title: Text(player.name),
        trailing: _setTrailingIcon(player),
      );
  }

  bool _isPlayerSelected(RankingPlayerData player) {
    if (_winner1Item?.userId == player.userId || _winner2Item?.userId == player.userId || _loser1Item?.userId == player.userId || _loser2Item?.userId == player.userId) return true;
    return false;
  }

  Widget _setTrailingIcon(RankingPlayerData player) {
    if (_isPlayerSelected(player)) return Icon(Icons.check_circle, color: Colors.greenAccent);
    return null;
  }

  void _updateChoosenPlayerState(RankingPlayerData player, PlayerChooserType type) {
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

  String _getDialogTitle(PlayerChooserType type) {
    if (type == PlayerChooserType.winner1 || type == PlayerChooserType.winner2) return "Vælg vinder";
    if (type == PlayerChooserType.loser1 || type == PlayerChooserType.loser2) return "Vælg taber";
    return "";
  }

  _saveMatch() async {
    Map<String, dynamic> a = {
      "year": 2018,
      "userId": "dfsdfs", // Den der registere kampen
      "matchDate": DateTime.now(), // Dato kampen er spillet
      "winner1": {
        "id": "asdasda",
        "name": "Christian",
        "photoUrl": "sdfsdfsdfsdf",
        "point": 34
      },
      "winner2": {
        "id": "asdasda",
        "name": "Christian",
        "photoUrl": "sdfsdfsdfsdf",
        "point": 34
      },
      "loser1": {
        "id": "asdasda",
        "name": "Christian",
        "photoUrl": "sdfsdfsdfsdf",
        "point": 34
      },
      "loser2": {
        "id": "asdasda",
        "name": "Christian",
        "photoUrl": "sdfsdfsdfsdf",
        "point": 34
      },
    };

    Map<String, dynamic> user = {
      "name": "Chrisitan",
      "userId": "det id jeg også har i users",
      "numberOfPlayedMatches": {
        "lost": 11,
        "won": 22
      },
      "photoUrl": "https://fsdfsdfsdf",
      "points": {
        "lost": 2,
        "won": 24,
      },
      "sex": "male"
    };
  }

  Future<Null> _selectDate(BuildContext context) async {
    var picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.day);

    if (picked != null) {
      setState(() {
        _matchDate = DateTimeHelpers.ddmmyyyy(picked);
      });
    }
  }
}
