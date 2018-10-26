import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_colors.dart';

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
  final bool winnerTeam1;
  final bool winnerTeam2;

  const LivescoreBoardPoints(
      {this.pointsTeam1,
      this.pointsTeam2,
      this.colorTeam1,
      this.colorTeam2,
      this.fontWeightTeam1 = FontWeight.normal,
      this.fontWeightTeam2 = FontWeight.normal,
      this.borderColorTeam1 = Colors.white,
      this.borderColorTeam2 = Colors.white,
      this.winnerTeam1 = false,
      this.winnerTeam2 = false,
      this.onLongPressPoints});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _teamPoints(pointsTeam1.toString(), 1, fontWeightTeam1, colorTeam1,
            borderColorTeam1, winnerTeam1),
        Expanded(
            child: Text("points",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white))),
        _teamPoints(pointsTeam2.toString(), 2, fontWeightTeam2, colorTeam2,
            borderColorTeam2, winnerTeam2)
      ],
    );
  }

  Widget _teamPoints(String points, int team, FontWeight fontWeight, Color pointTextColor, Color borderColor, bool teamWinner) {
    return Expanded(
      child: Stack(
        overflow: Overflow.visible,
        fit: StackFit.passthrough,
        children: <Widget>[
          GestureDetector(
            onLongPress: () {
              onLongPressPoints(team);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 2.5),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.black,
                  border: Border.all(
                      color: borderColor,
                      style: BorderStyle.solid,
                      width: 2.0)),
              child: Text(points,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: fontWeight,
                      fontSize: 25.0,
                      color: pointTextColor,
                      fontFamily: "Scoreboard")),
            ),
          ),
          teamWinner ? Positioned(
            top: 50.0,
            left: 42.0,
            child: Icon(FontAwesomeIcons.trophy, color: SilkeborgBeachvolleyColors.gold),
          ) : Container()
        ],
      ),
    );
  }
}
