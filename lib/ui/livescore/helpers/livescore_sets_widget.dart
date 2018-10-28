import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class LivescoreBoardSets extends StatelessWidget {
  final int setTeam1;
  final int setTeam2;
  final Color colorTeam1;
  final Color colorTeam2;
  final FontWeight fontWeightTeam1;
  final FontWeight fontWeightTeam2;

  LivescoreBoardSets(
      {this.setTeam1,
      this.setTeam2,
      this.colorTeam1,
      this.colorTeam2,
      this.fontWeightTeam1 = FontWeight.normal,
      this.fontWeightTeam2 = FontWeight.normal});

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
        child: Text(setTeam1.toString(),
            textAlign: TextAlign.end,
            style: TextStyle(
                fontSize: 16.0,
                color: colorTeam1,
                fontFamily: "Scoreboard",
                fontWeight: fontWeightTeam1)),
      ),
      Expanded(
        child: Text(FlutterI18n.translate(context, "livescore.livescoreSetsWidget.string1"),
            textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
      ),
      Expanded(
          child: Text(setTeam2.toString(),
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 16.0,
                  color: colorTeam2,
                  fontFamily: "Scoreboard",
                  fontWeight: fontWeightTeam2)))
    ]);
  }
}
