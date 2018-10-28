import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/helpers/circle_profile_image.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_theme.dart';
import 'package:silkeborgbeachvolley/ui/helpers/chip_header_widget.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_data_class.dart';

class AdminRankingPlayersPlayerInfo extends StatelessWidget {
  final RankingPlayerData player;

  const AdminRankingPlayersPlayerInfo({Key key, @required this.player})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(FlutterI18n.translate(
          context, "ranking.adminRankingPlayersPlayerInfoWidget.string1")),
      children: <Widget>[
        Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleProfileImage(
                  size: 60.0,
                  url: player.photoUrl
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text(player.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0)),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Tooltip(
                      message: FlutterI18n.translate(context,
                          "ranking.adminRankingPlayersPlayerInfoWidget.string2"),
                      child: Icon(FontAwesomeIcons.idCard, size: 12.0)),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(player.userId, textAlign: TextAlign.center),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ChipHeader(
                FlutterI18n.translate(context,
                    "ranking.adminRankingPlayersPlayerInfoWidget.string3"),
                roundedCorners: false,
                expanded: true,
                textAlign: TextAlign.center,
                backgroundColor: SilkeborgBeachvolleyTheme.headerBackground,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(children: <Widget>[
                    Text(FlutterI18n.translate(context,
                        "ranking.adminRankingPlayersPlayerInfoWidget.string4")),
                    Text(player.numberOfPlayedMatches.won.toString())
                  ]),
                  Column(children: <Widget>[
                    Text(FlutterI18n.translate(context,
                        "ranking.adminRankingPlayersPlayerInfoWidget.string5")),
                    Text(player.numberOfPlayedMatches.lost.toString())
                  ]),
                  Column(children: <Widget>[
                    Text(FlutterI18n.translate(context,
                        "ranking.adminRankingPlayersPlayerInfoWidget.string6")),
                    Text(player.numberOfPlayedMatches.total.toString())
                  ])
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ChipHeader(
                FlutterI18n.translate(context,
                    "ranking.adminRankingPlayersPlayerInfoWidget.string7"),
                roundedCorners: false,
                expanded: true,
                textAlign: TextAlign.center,
                backgroundColor: SilkeborgBeachvolleyTheme.headerBackground,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(children: <Widget>[
                    Text("Vundne"),
                    Text(player.points.won.toString())
                  ]),
                  Column(children: <Widget>[
                    Text("Tabte"),
                    Text(player.points.lost.toString())
                  ]),
                  Column(children: <Widget>[
                    Text("Samlet"),
                    Text(player.points.total.toString())
                  ])
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
