import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_colors.dart';
import 'package:silkeborgbeachvolley/ui/helpers/chip_header_widget.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_data_class.dart';

class AdminRankingPlayersPlayerInfo extends StatelessWidget {
  final RankingPlayerData player;

  const AdminRankingPlayersPlayerInfo({Key key, @required this.player}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
            title: Text("Spiller info"),
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage:
                        CachedNetworkImageProvider(player.photoUrl),
                    radius: 30.0,
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
                        message: "Bruger id",
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
                  "Kampe",
                  roundedCorners: false,
                  expanded: true,
                  textAlign: TextAlign.center,
                  backgroundColor: SilkeborgBeachvolleyColors.headerBackground,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(children: <Widget>[
                      Text("Vundne"),
                      Text(player.numberOfPlayedMatches.won.toString())
                    ]),
                    Column(children: <Widget>[
                      Text("Tabte"),
                      Text(player.numberOfPlayedMatches.lost.toString())
                    ]),
                    Column(children: <Widget>[
                      Text("Samlet"),
                      Text(player.numberOfPlayedMatches.total.toString())
                    ])
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ChipHeader(
                  "Point",
                  roundedCorners: false,
                  expanded: true,
                  textAlign: TextAlign.center,
                  backgroundColor: SilkeborgBeachvolleyColors.headerBackground,
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
