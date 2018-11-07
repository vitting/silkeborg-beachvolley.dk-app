import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/ui/livescore/board/livescore_set_score_row_widget.dart';

class LivescoreSetScore extends StatelessWidget {
  final List<LivescoreSetScoreRow> setRows;
  final double fontSize;
  final Color color;

  const LivescoreSetScore(
      {Key key, this.setRows, this.fontSize = 14.0, this.color = Colors.white})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return setRows != null && setRows.length == 0
        ? Container()
        : Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Text(
                      FlutterI18n.translate(
                          context, "livescore.livescoreSetScoreWidget.string1"),
                      style: TextStyle(color: color, fontSize: fontSize)),
                ),
                Column(
                  children: setRows,
                )
              ],
            ),
          );
  }
}
