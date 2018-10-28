import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_theme.dart';

class LivescoreSetScoreRow extends StatelessWidget {
  final int setTeam1;
  final int setTeam2;
  final int pointsTeam1;
  final int pointsTeam2;
  final int setTime;
  final double fontSize;
  final Color color;

  const LivescoreSetScoreRow(
      {Key key,
      this.setTeam1 = 0,
      this.setTeam2 = 0,
      this.pointsTeam1 = 0,
      this.pointsTeam2 = 0,
      this.setTime = 0,
      this.fontSize = 14.0,
      this.color = Colors.white})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(setTeam1.toString(),
              style: TextStyle(
                  color: color, fontFamily: SilkeborgBeachvolleyTheme.scoreboardFont, fontSize: fontSize)),
          Text("  (", style: TextStyle(color: color, fontSize: fontSize)),
          Text(pointsTeam1.toString().padLeft(2, "0"),
              style: TextStyle(
                  color: color, fontFamily: SilkeborgBeachvolleyTheme.scoreboardFont, fontSize: fontSize)),
          Text(")  [", style: TextStyle(color: color, fontSize: fontSize)),
          Text(setTime.toString(),
              style: TextStyle(
                  color: color, fontFamily: SilkeborgBeachvolleyTheme.scoreboardFont, fontSize: fontSize)),
          Text(" min", style: TextStyle(color: color, fontSize: fontSize)),
          Text("]  (", style: TextStyle(color: color, fontSize: fontSize)),
          Text(pointsTeam2.toString().padLeft(2, "0"),
              style: TextStyle(
                  color: color, fontFamily: SilkeborgBeachvolleyTheme.scoreboardFont, fontSize: fontSize)),
          Text(")  ", style: TextStyle(color: color, fontSize: fontSize)),
          Text(setTeam2.toString(),
              style: TextStyle(
                  color: color, fontFamily: SilkeborgBeachvolleyTheme.scoreboardFont, fontSize: fontSize)),
        ],
      ),
    );
  }
}
