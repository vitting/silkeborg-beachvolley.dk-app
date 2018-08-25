import 'package:flutter/material.dart';

class ScoreBoardPoints extends StatelessWidget {
  final int scoreTeam1;
  final int scoreTeam2;

  ScoreBoardPoints(this.scoreTeam1, this.scoreTeam2);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Text(scoreTeam1.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0))),
          Expanded(flex: 1, child: Text("points", textAlign: TextAlign.center)),
          Expanded(
              flex: 1,
              child: Text(scoreTeam2.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0)))
        ],
      ),
    );
  }
}