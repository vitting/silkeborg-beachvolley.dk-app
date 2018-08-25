import 'package:flutter/material.dart';

class ScoreBoardSets extends StatelessWidget {
  final int setTeam1;
  final int setTeam2;

  ScoreBoardSets(this.setTeam1, this.setTeam2);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
      child: Row(children: <Widget>[
        Expanded(
          flex: 1,
          child: Text(setTeam1.toString(), textAlign: TextAlign.end),
        ),
        Expanded(
          flex: 1,
          child: Text("set", textAlign: TextAlign.center),
        ),
        Expanded(flex: 1, child: Text(setTeam2.toString(), textAlign: TextAlign.start))
      ]),
    );
  }
}