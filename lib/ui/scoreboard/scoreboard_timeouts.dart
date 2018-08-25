import 'package:flutter/material.dart';

class ScoreBoardTimeouts extends StatelessWidget {
  final int timeoutTeam1;
  final int timeoutTeam2;

  ScoreBoardTimeouts(this.timeoutTeam1, this.timeoutTeam2);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
      child: Row(
        children: <Widget>[
          Expanded(flex: 1, child: Text(timeoutTeam1.toString(), textAlign: TextAlign.end)),
          Expanded(
              flex: 1, child: Text("timeouts", textAlign: TextAlign.center)),
          Expanded(flex: 1, child: Text(timeoutTeam2.toString(), textAlign: TextAlign.start)),
        ],
      ),
    );
  }
}