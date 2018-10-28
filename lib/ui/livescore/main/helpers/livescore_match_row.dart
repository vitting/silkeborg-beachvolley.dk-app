import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_colors.dart';
import 'package:silkeborgbeachvolley/ui/helpers/chip_header_widget.dart';
import 'package:silkeborgbeachvolley/ui/livescore/helpers/livescore_data.dart';
import 'package:silkeborgbeachvolley/ui/livescore/helpers/livescore_live_dot_widget.dart';

class LivescoreMatchRow extends StatelessWidget {
  final LivescoreData match;
  final ValueChanged<LivescoreData> onTapRow;
  final ValueChanged<LivescoreData> onLongPressRow;
  final bool isLive;
  final bool isFinished;
  const LivescoreMatchRow(
      {Key key,
      this.match,
      this.onTapRow,
      this.onLongPressRow,
      this.isLive = false,
      this.isFinished = false})
      : super(key: key);
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
                  child: ChipHeader(match.matchDateWithTimeFormatted(context),
                      child: isLive == false
                          ? null
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                LivescoreLiveDot(
                                  showDot: true,
                                  rightMargin: 7.0,
                                ),
                                Text(match.matchDateWithTimeFormatted(context),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14.0))
                              ],
                            ),
                      expanded: true,
                      roundedCorners: false,
                      textAlign: TextAlign.center,
                      backgroundColor: Colors.blue[700]),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(match.title, textAlign: TextAlign.center),
                  )
                ],
              ),
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
                    Text(match.namePlayer2Team1, textAlign: TextAlign.center),
                    isLive
                        ? Text(match.pointsTeam1.toString(),
                            textAlign: TextAlign.center)
                        : Container(),
                    isFinished && match.winnerTeam == 1
                        ? Padding(
                            padding: const EdgeInsets.only(top: 3.0),
                            child: Icon(FontAwesomeIcons.trophy,
                                color: SilkeborgBeachvolleyColors.gold,
                                size: 16.0),
                          )
                        : Container()
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Text("vs.", textAlign: TextAlign.center),
                  isLive || isFinished
                      ? Text("${match.setTeam1} - ${match.setTeam2}")
                      : Container()
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(match.namePlayer1Team2, textAlign: TextAlign.center),
                    Text(match.namePlayer2Team2, textAlign: TextAlign.center),
                    isLive
                        ? Text(match.pointsTeam2.toString(),
                            textAlign: TextAlign.center)
                        : Container(),
                    isFinished && match.winnerTeam == 2
                        ? Padding(
                            padding: const EdgeInsets.only(top: 3.0),
                            child: Icon(FontAwesomeIcons.trophy,
                                color: SilkeborgBeachvolleyColors.gold,
                                size: 16.0),
                          )
                        : Container()
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
