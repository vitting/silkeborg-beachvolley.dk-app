import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class RankingMatchesHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 2.0),
                  color: Colors.blue,
                  child: Text(
                    FlutterI18n.translate(context, "ranking.rankingMatchesHeaderWidget.string1"),
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 2.0),
                  color: Colors.blue[700],
                  child: Text(
                    FlutterI18n.translate(context, "ranking.rankingMatchesHeaderWidget.string2"),
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
