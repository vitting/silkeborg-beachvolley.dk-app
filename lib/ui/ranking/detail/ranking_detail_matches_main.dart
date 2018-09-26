import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/loader_spinner.dart';
import 'package:silkeborgbeachvolley/ui/ranking/detail/ranking_detail_matches_header.dart';
import 'package:silkeborgbeachvolley/ui/ranking/detail/ranking_detail_matches_row.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_match_data.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_match_player_data_class.dart';

class RankingDetailMatches extends StatelessWidget {
  final Future<List<RankingMatchData>> matches;
  final String userId;
  const RankingDetailMatches({Key key, this.matches, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _main();
  }

  Widget _main() {
    return FutureBuilder(
      future: matches,
      builder: (BuildContext context,
          AsyncSnapshot<List<RankingMatchData>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) return LoaderSpinner();

        return Container(
          constraints: BoxConstraints.expand(),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.length + 1,
            itemBuilder: (BuildContext context, int position) {
              if (position == 0) return RankingDetailMatchesHeader();

              RankingMatchData item = snapshot.data[position - 1];
              return Card(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(DateTimeHelpers.ddMMyyyy(item.matchDate)),
                          IconButton(
                            onPressed: () async {
                              await _showMatchInfo(context, item);
                            },
                            color: Colors.blueAccent,
                            icon: Icon(Icons.info_outline),
                          )
                        ],
                      ),
                      RankingMatchesRow(
                        winner: item.winner1,
                        loser: item.loser1,
                        userId: userId,
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      RankingMatchesRow(
                        winner: item.winner2,
                        loser: item.loser2,
                        userId: userId,
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _showMatchInfo(BuildContext context, RankingMatchData match) async {
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
            child: _infoPlayerRow(match.winner1),
          ),
           _infoPlayerRow(match.winner2),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: _infoPlayerHeader("Tabere"),
          ),
           _infoPlayerRow(match.loser1),
          SizedBox(height: 10.0),
           Padding(
             padding: const EdgeInsets.symmetric(vertical: 10.0),
             child: _infoPlayerRow(match.loser2),
           )
        ],
      )
    );
  }

  Widget _infoPlayerHeader(String text) {
    return Text(text, textAlign: TextAlign.center, style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold));
  }

  Widget _infoPlayerRow(RankingMatchPlayerData player) {
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
}
