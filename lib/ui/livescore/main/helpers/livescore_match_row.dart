import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/livescore/helpers/livescore_data.dart';

class LivescoreMatchRow extends StatelessWidget {
  final LivescoreData match;
  final ValueChanged<LivescoreData> onTapRow;
  final ValueChanged<LivescoreData> onLongPressRow;

  const LivescoreMatchRow({Key key, this.match, this.onTapRow, this.onLongPressRow}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onLongPress: () {
          onLongPressRow(match);
        },
        onTap: () {
          onTapRow(match);
        },
        title: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(match.matchDateWithTimeFormatted(context), textAlign: TextAlign.center),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
              child: Text(match.title, textAlign: TextAlign.center),
            )
              ],
            )
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(match.namePlayer1Team1, textAlign: TextAlign.center),
                    Text(match.namePlayer2Team1, textAlign: TextAlign.center)
                  ],
                ),
              ),
              Row(
                children: <Widget>[Text("vs.", textAlign: TextAlign.center)],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(match.namePlayer1Team2, textAlign: TextAlign.center),
                    Text(match.namePlayer2Team2, textAlign: TextAlign.center)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}