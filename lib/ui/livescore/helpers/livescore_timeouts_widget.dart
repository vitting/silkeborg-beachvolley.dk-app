import 'package:flutter/material.dart';

class LivescoreBoardTimeouts extends StatelessWidget {
  final int timeoutTeam1;
  final int timeoutTeam2;
  final Color colorTeam1;
  final Color colorTeam2;
  final FontWeight fontWeightTeam1;
  final FontWeight fontWeightTeam2;

  LivescoreBoardTimeouts(
      {this.timeoutTeam1,
      this.timeoutTeam2,
      this.colorTeam1,
      this.colorTeam2,
      this.fontWeightTeam1 = FontWeight.normal,
      this.fontWeightTeam2 = FontWeight.normal});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: Text(timeoutTeam1.toString(),
                textAlign: TextAlign.end,
                style: TextStyle(
                    fontSize: 16.0,
                    color: colorTeam1,
                    fontFamily: "Scoreboard",
                    fontWeight: fontWeightTeam1))),
        Expanded(
            child: Text("timeouts",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white))),
        Expanded(
            child: Text(timeoutTeam2.toString(),
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 16.0,
                    color: colorTeam2,
                    fontFamily: "Scoreboard",
                    fontWeight: fontWeightTeam2))),
      ],
    );
  }
}
