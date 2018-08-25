import 'package:flutter/material.dart';

class ScoreBoardTime extends StatelessWidget {
  final String matchtime;

  ScoreBoardTime(this.matchtime);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Text("Match start $matchtime")],
      ),
    );
  }
}