import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/livescore/helpers/livescore_data.dart';
import 'package:silkeborgbeachvolley/ui/livescore/helpers/livescore_message_widget.dart';
import 'package:silkeborgbeachvolley/ui/livescore/helpers/livescore_names_widget.dart';
import 'package:silkeborgbeachvolley/ui/livescore/helpers/livescore_points_widget.dart';
import 'package:silkeborgbeachvolley/ui/livescore/helpers/livescore_sets_widget.dart';
import 'package:silkeborgbeachvolley/ui/livescore/helpers/livescore_time_widget.dart';
import 'package:silkeborgbeachvolley/ui/livescore/helpers/livescore_timeouts_widget.dart';
import 'package:silkeborgbeachvolley/ui/livescore/helpers/livescore_title_widget.dart';

class LivescoreBoard extends StatelessWidget {
  final LivescoreData match;
  final Color colorTeam1;
  final Color colorTeam2;
  final FontWeight fontWeightTeam1;
  final FontWeight fontWeightTeam2;
  final Color pointsBorderColorTeam1;
  final Color pointsBorderColorTeam2;
  final bool winnerTeam1;
  final bool winnerTeam2;
  final Stream<String> messageStream;
  final ValueChanged<int> onLongPressPoints;
  final ValueChanged<bool> onDoubleTapMessage;
  final bool showIsLiveIndicator;
  const LivescoreBoard(
      {Key key,
      this.match,
      this.colorTeam1 = Colors.white,
      this.colorTeam2 = Colors.white,
      this.pointsBorderColorTeam1 = Colors.white,
      this.pointsBorderColorTeam2 = Colors.white,
      this.onLongPressPoints,
      this.onDoubleTapMessage,
      this.fontWeightTeam1 = FontWeight.normal,
      this.fontWeightTeam2 = FontWeight.normal,
      this.winnerTeam1 = false,
      this.winnerTeam2 = false,
      this.messageStream,
      this.showIsLiveIndicator
    })
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      color: Colors.black,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: LivescoreBoardTitle(
              title: match.title,
            ),
          ),
          LivescoreBoardTime(
            isLive: showIsLiveIndicator,
            matchtime: match.matchDateWithTimeFormatted(context),
            matchStartedAt: match.matchStartedAtTimeFormatted(),
            matchEndedAt: match.matchEndedAtTimeFormatted(),
            matchTotal: match.matchPlayTime(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: LivescoreBoardNames(
              namePlayer1Team1: match.namePlayer1Team1,
              namePlayer2Team1: match.namePlayer2Team1,
              namePlayer1Team2: match.namePlayer1Team2,
              namePlayer2Team2: match.namePlayer2Team2,
              colorTeam1: colorTeam1,
              colorTeam2: colorTeam2,
              fontWeightTeam1: fontWeightTeam1,
              fontWeightTeam2: fontWeightTeam2
            ),
          ),
          LivescoreBoardSets(
              setTeam1: match.setTeam1,
              setTeam2: match.setTeam2,
              colorTeam1: colorTeam1,
              colorTeam2: colorTeam2,
              fontWeightTeam1: fontWeightTeam1,
              fontWeightTeam2: fontWeightTeam2
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: LivescoreBoardPoints(
              pointsTeam1: match.pointsTeam1,
              pointsTeam2: match.pointsTeam2,
              colorTeam1: colorTeam1,
              colorTeam2: colorTeam2,
              fontWeightTeam1: fontWeightTeam1,
              fontWeightTeam2: fontWeightTeam2,
              borderColorTeam1: pointsBorderColorTeam1,
              borderColorTeam2: pointsBorderColorTeam2,
              winnerTeam1: winnerTeam1,
              winnerTeam2: winnerTeam2,
              onLongPressPoints: onLongPressPoints,
            ),
          ),
          LivescoreBoardTimeouts(
              timeoutTeam1: match.timeoutsTeam1,
              timeoutTeam2: match.timeoutsTeam2,
              colorTeam1: colorTeam1,
              colorTeam2: colorTeam2,
              fontWeightTeam1: fontWeightTeam1,
              fontWeightTeam2: fontWeightTeam2
              ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child:LivescoreMatchMessage(
              onDoubleTapMessage: onDoubleTapMessage,
              messageStream: messageStream,
            )
          )
        ],
      ),
    );
  }
}
