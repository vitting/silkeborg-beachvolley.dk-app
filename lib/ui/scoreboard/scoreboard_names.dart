import 'package:flutter/material.dart';

class ScoreBoardNames extends StatelessWidget {
  final String nameTeam1;
  final String nameTeam2;

  ScoreBoardNames(this.nameTeam1, this.nameTeam2);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
      child: Row(children: <Widget>[
        Expanded(
          flex: 1,
          child: Text(nameTeam1,
              textAlign: TextAlign.center, style: TextStyle(fontSize: 15.0)),
        ),
        Expanded(
          flex: 1,
          child: Text(nameTeam2,
              textAlign: TextAlign.center, style: TextStyle(fontSize: 15.0)),
        )
      ]),
    );
  }
}