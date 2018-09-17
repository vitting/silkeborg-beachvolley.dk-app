import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/createMatch/create_player_choose_date.dart';
import 'package:silkeborgbeachvolley/ui/ranking/createMatch/create_player_chooser.dart';
import 'package:silkeborgbeachvolley/ui/ranking/createMatch/create_player_chooser_row.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_firestore.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_match_data.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_data.dart';
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
        body: Builder(builder: (BuildContext context) {
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
                title: "Vindere",
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
                title: "Tabere",
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
        }));
  }


//CHRISTIAN: Vi skal lave det sådan at man kan sætte set score, men det skal være optional
  Widget _saveButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: FlatButton.icon(
            label: Text("Gem kampen"),
            icon: Icon(FontAwesomeIcons.volleyballBall),
            onPressed: () {
              _saveMatch(context);
            },
          ),
        )
      ],
    );
  }

  _showPlayers(BuildContext context, PlayerChooserType type) async {
    List<Widget> widgets =
        _listOfPlayers.map<ListTile>((RankingPlayerData player) {
      return _generatePlayerListTile(player);
    }).toList();

    RankingPlayerData player = await showDialog<RankingPlayerData>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
              title: Text(_getDialogTitle(type)), children: widgets);
        });

    _updateChoosenPlayerState(player, type);
  }

  Widget _generatePlayerListTile(RankingPlayerData player) {
    return ListTile(
      onTap: () {
        if (!_isPlayerSelected(player))
          Navigator.of(context).pop<RankingPlayerData>(player);
      },
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(player.photoUrl),
      ),
      title: Text(player.name),
      trailing: _setTrailingIcon(player),
    );
  }

  bool _isPlayerSelected(RankingPlayerData player) {
    if (_winner1Item?.userId == player.userId ||
        _winner2Item?.userId == player.userId ||
        _loser1Item?.userId == player.userId ||
        _loser2Item?.userId == player.userId) return true;
    return false;
  }

  Widget _setTrailingIcon(RankingPlayerData player) {
    if (_isPlayerSelected(player))
      return Icon(Icons.check_circle, color: Colors.greenAccent);
    return null;
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

  String _getDialogTitle(PlayerChooserType type) {
    if (type == PlayerChooserType.winner1 || type == PlayerChooserType.winner2)
      return "Vælg vinder";
    if (type == PlayerChooserType.loser1 || type == PlayerChooserType.loser2)
      return "Vælg taber";
    return "";
  }

  _saveMatch(BuildContext context) async {
    if (_isMatchValid()) {
      RankingMatchData match = RankingMatchData(
          userId: Home.loggedInUser.uid,
          matchDate: _matchDate,
          createdDate: FieldValue.serverTimestamp(),
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

      await RankingFirestore.saveMatch(match);
      Navigator.of(context).pop();
    } else {
      setState(() {});
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Du skal udfylde de felter der er røde før de kan gemme kampen."),
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
