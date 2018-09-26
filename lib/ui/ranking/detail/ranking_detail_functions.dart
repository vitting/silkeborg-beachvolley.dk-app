import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_match_data.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_match_player_data_class.dart';

Future<void> showMatchInfo(BuildContext context, RankingMatchData match, String userId) async {
    return await showDialog<void>(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        title: Text("Kamp info"),
        contentPadding: EdgeInsets.all(20.0),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(DateTimeHelpers.ddMMyyyy(match.matchDate), textAlign: TextAlign.center, style: TextStyle(fontSize: 15.0)),
          ),
          _infoPlayerHeader("Vindere"),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: _infoPlayerRow(match.winner1, userId),
          ),
           _infoPlayerRow(match.winner2, userId),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: _infoPlayerHeader("Tabere"),
          ),
           _infoPlayerRow(match.loser1, userId),
          SizedBox(height: 10.0),
           Padding(
             padding: const EdgeInsets.symmetric(vertical: 10.0),
             child: _infoPlayerRow(match.loser2, userId),
           )
        ],
      )
    );
  }

  Widget _infoPlayerHeader(String text) {
    return Text(text, textAlign: TextAlign.center, style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold));
  }

  Widget _infoPlayerRow(RankingMatchPlayerData player, String userId) {
      FontWeight fontWeight = FontWeight.normal;
      if (player.id == userId) fontWeight = FontWeight.bold;
      return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                  radius: 15.0,
                  backgroundImage:
                      CachedNetworkImageProvider(player.photoUrl),
                ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(player.name, style: TextStyle(fontSize: 15.0, fontWeight: fontWeight)),
              ),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(FontAwesomeIcons.trophy, size: 12.0, color: Colors.grey),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(player.points.toString(), style: TextStyle(fontSize: 15.0),),
                  )
                ],
              )
            ],
          );
    }