import 'package:flutter/material.dart';
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
      this.matchTotal, this.isLive = false});
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
            Text("Kamp dato", style: TextStyle(color: Colors.white)),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text("$matchtime",
                  style:
                      TextStyle(color: Colors.white, fontFamily: "Scoreboard", fontSize: 12.0)),
            ),
            
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top:10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              matchStartedAt == null
                  ? Container()
                  : Column(
                      children: <Widget>[
                        Text("Startet", style: TextStyle(color: Colors.white, fontSize: 12.0)),
                        Text("$matchStartedAt",
                            style: TextStyle(
                                color: Colors.white, fontFamily: "Scoreboard", fontSize: 12.0))
                      ],
                    ),
              matchEndedAt == null
                  ? Container()
                  : Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text("Sluttede",
                                style: TextStyle(color: Colors.white, fontSize: 12.0)),
                            Text("$matchEndedAt",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Scoreboard", fontSize: 12.0))
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
                            Text("Total min.",
                                style: TextStyle(color: Colors.white, fontSize: 12.0)),
                            Text("$matchTotal",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Scoreboard", fontSize: 12.0))
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
