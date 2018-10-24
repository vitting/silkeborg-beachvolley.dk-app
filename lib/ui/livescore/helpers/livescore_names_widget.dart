import 'package:flutter/material.dart';

class LivescoreBoardNames extends StatelessWidget {
  final String namePlayer1Team1;
  final String namePlayer2Team1;
  final String namePlayer1Team2;
  final String namePlayer2Team2;
  final Color colorTeam1;
  final Color colorTeam2;
  final FontWeight fontWeightTeam1;
  final FontWeight fontWeightTeam2;

  const LivescoreBoardNames({@required this.namePlayer1Team1, @required this.namePlayer2Team1, @required this.namePlayer1Team2, @required this.namePlayer2Team2, this.colorTeam1, this.colorTeam2, this.fontWeightTeam1 = FontWeight.normal, this.fontWeightTeam2 = FontWeight.normal});

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
        child: Column(
          children: <Widget>[
            Text(namePlayer1Team1,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15.0,
                    color: colorTeam1,
                    fontFamily: "Scoreboard",
                    fontWeight: fontWeightTeam1)),
            Text(namePlayer2Team1,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15.0,
                    color: colorTeam2,
                    fontFamily: "Scoreboard",
                    fontWeight: fontWeightTeam1))
          ],
        ),
      ),
      Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text("vs.",style: TextStyle(
                      color: colorTeam2,
                      fontWeight: fontWeightTeam1)),
          )
        ],
      ),
      Expanded(
          child: Column(
        children: <Widget>[
          Text(namePlayer1Team2,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontFamily: "Scoreboard",
                  fontWeight: fontWeightTeam2)),
          Text(namePlayer2Team2,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontFamily: "Scoreboard",
                  fontWeight: fontWeightTeam2))
        ],
      ))
    ]);
  }
}
