import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_theme.dart';
import 'package:silkeborgbeachvolley/ui/livescore/helpers/livescore_live_dot_widget.dart';

class LivescoreBoardTime extends StatelessWidget {
  final String matchtime;
  final String matchStartedAt;
  final String matchEndedAt;
  final String matchTotal;
  final bool isLive;

  LivescoreBoardTime(
      {this.matchtime,
      this.matchStartedAt,
      this.matchEndedAt,
      this.matchTotal,
      this.isLive = false});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LivescoreLiveDot(
              showDot: isLive,
              rightMargin: 10.0,
            ),
            Text(
                FlutterI18n.translate(
                    context, "livescore.livescoreTimeWidget.string1"),
                style: TextStyle(color: Colors.white)),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text("$matchtime",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: SilkeborgBeachvolleyTheme.scoreboardFont,
                      fontSize: 12.0)),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              matchStartedAt == null
                  ? Container()
                  : Column(
                      children: <Widget>[
                        Text(
                            FlutterI18n.translate(context,
                                "livescore.livescoreTimeWidget.string2"),
                            style:
                                TextStyle(color: Colors.white, fontSize: 12.0)),
                        Text("$matchStartedAt",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily:
                                    SilkeborgBeachvolleyTheme.scoreboardFont,
                                fontSize: 12.0))
                      ],
                    ),
              matchEndedAt == null
                  ? Container()
                  : Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                                FlutterI18n.translate(context,
                                    "livescore.livescoreTimeWidget.string3"),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12.0)),
                            Text("$matchEndedAt",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: SilkeborgBeachvolleyTheme
                                        .scoreboardFont,
                                    fontSize: 12.0))
                          ],
                        )
                      ],
                    ),
              matchTotal == null
                  ? Container()
                  : Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                                FlutterI18n.translate(context,
                                    "livescore.livescoreTimeWidget.string4"),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12.0)),
                            Text("$matchTotal",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: SilkeborgBeachvolleyTheme
                                        .scoreboardFont,
                                    fontSize: 12.0))
                          ],
                        )
                      ],
                    )
            ],
          ),
        ),
        Row(
          children: <Widget>[],
        )
      ],
    );
  }
}
