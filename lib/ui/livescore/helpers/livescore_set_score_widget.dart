import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/livescore/helpers/livescore_set_score_row_widget.dart';

class LivescoreSetScore extends StatelessWidget {
  final List<LivescoreSetScoreRow> setRows;
  final double fontSize;
  final Color color;

  const LivescoreSetScore({Key key, this.setRows, this.fontSize = 14.0, this.color = Colors.white}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return setRows != null && setRows.length == 0 ? Container() : Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Text("Spillede sets", style: TextStyle(color: color, fontSize: fontSize)),
          ),
          Column(
            children: setRows,
          )
        ],
      ),
    );
  }
}