import 'package:flutter/material.dart';

class LivescoreBoardPoints extends StatelessWidget {
  final int pointsTeam1;
  final int pointsTeam2;
  final Color colorTeam1;
  final Color colorTeam2;
  final FontWeight fontWeightTeam1;
  final FontWeight fontWeightTeam2;
  final ValueChanged<int> onLongPressPoints;
  final Color borderColorTeam1;
  final Color borderColorTeam2;

  const LivescoreBoardPoints(
      {this.pointsTeam1,
      this.pointsTeam2,
      this.colorTeam1,
      this.colorTeam2,
      this.fontWeightTeam1 = FontWeight.normal,
      this.fontWeightTeam2 = FontWeight.normal,
      this.borderColorTeam1 = Colors.white,
      this.borderColorTeam2 = Colors.white,
      this.onLongPressPoints});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: GestureDetector(
          onLongPress: () {
            onLongPressPoints(1);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 2.5),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.black,
                border: Border.all(
                    color: borderColorTeam1, style: BorderStyle.solid, width: 2.0)),
            child: Text(pointsTeam1.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: fontWeightTeam1,
                    fontSize: 25.0,
                    color: colorTeam1,
                    fontFamily: "Scoreboard")),
          ),
        )),
        Expanded(
            child: Text("points",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white))),
        Expanded(
            child: GestureDetector(
          onLongPress: () {
            onLongPressPoints(2);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 2.5),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.black,
                border: Border.all(
                    color: borderColorTeam2, style: BorderStyle.solid, width: 2.0)),
            child: Text(pointsTeam2.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: fontWeightTeam2,
                    fontSize: 25.0,
                    color: colorTeam2,
                    fontFamily: "Scoreboard")),
          ),
        ))
      ],
    );
  }
}
