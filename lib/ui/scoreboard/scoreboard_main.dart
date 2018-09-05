import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'package:silkeborgbeachvolley/ui/scoreboard/scoreboard_controls_points.dart';
import 'package:silkeborgbeachvolley/ui/scoreboard/scoreboard_controls_sets.dart';
import 'package:silkeborgbeachvolley/ui/scoreboard/scoreboard_controls_timeouts.dart';
import 'package:silkeborgbeachvolley/ui/scoreboard/scoreboard_controls_winner.dart';
import 'package:silkeborgbeachvolley/ui/scoreboard/scoreboard_names.dart';
import 'package:silkeborgbeachvolley/ui/scoreboard/scoreboard_points.dart';
import 'package:silkeborgbeachvolley/ui/scoreboard/scoreboard_sets.dart';
import 'package:silkeborgbeachvolley/ui/scoreboard/scoreboard_time.dart';
import 'package:silkeborgbeachvolley/ui/scoreboard/scoreboard_timeouts.dart';

class ScoreBoard extends StatefulWidget {
  static final routeName = "/scoreboard";
  @override
  _ScoreBoardState createState() => _ScoreBoardState();
}

class _ScoreBoardState extends State<ScoreBoard> {
  String _matchTime = "12:01";
  String _nameTeam1 = "Mogens Kjeldsen og Trine Kjeldsen";
  String _nameTeam2 = "Christian Nicolaisen og Carsten Højmark";
  int _setTeam1 = 0;
  int _setTeam2 = 0;
  int _scoreTeam1 = 0;
  int _scoreTeam2 = 0;
  int _timeoutTeam1 = 0;
  int _timeoutTeam2 = 0;

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
      title: "Silkeborg Beachvolley",
      body: _main()
    );
  }

  Widget _main() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          ScoreBoardTime(_matchTime),
          ScoreBoardNames(_nameTeam1, _nameTeam2),
          ScoreBoardSets(_setTeam1, _setTeam2),
          ScoreBoardPoints(_scoreTeam1, _scoreTeam2),
          ScoreBoardTimeouts(_timeoutTeam1, _timeoutTeam2),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
            child: Divider(
              color: Colors.black,
            ),
          ),
          ScoreBoardControlsSets(_addSet, _removeSet),
          ScoreBoardControlsPoints(_addPoint, _removePoint),
          ScoreBoardControlsTimeouts(_addTimeout, _removeTimeout),
          ScoreBoardControlsWinners(_setWinner, _matchWinner)
        ],
      ),
    );
  }

  void _addSet(int team) {
    setState(() {
      switch (team) {
        case 1:
          _setTeam1++;
          break;
        case 2:
          _setTeam2++;
          break;
      }
    });
  }

  void _removeSet(int team) {
    setState(() {
      switch (team) {
        case 1:
          _setTeam1--;
          break;
        case 2:
          _setTeam2--;
          break;
      }
    });
  }

  void _addPoint(int team) {
    setState(() {
      switch (team) {
        case 1:
          _scoreTeam1++;
          break;
        case 2:
          _scoreTeam2++;
          break;
      }
    });
  }

  void _removePoint(int team) {
    setState(() {
      switch (team) {
        case 1:
          _scoreTeam1--;
          break;
        case 2:
          _scoreTeam2--;
          break;
      }
    });
  }

  void _addTimeout(int team) {
    setState(() {
      switch (team) {
        case 1:
          _timeoutTeam1++;
          break;
        case 2:
          _timeoutTeam2++;
          break;
      }
    });
  }

  void _removeTimeout(int team) {
    setState(() {
      switch (team) {
        case 1:
          _timeoutTeam1--;
          break;
        case 2:
          _timeoutTeam2--;
          break;
      }
    });
  }

  void _matchWinner(int team) {
    print("Match winner $team");
  }

  void _setWinner(int team) {
    print("Set winner $team");
  }
}
