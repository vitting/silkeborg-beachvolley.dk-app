import 'dart:async';

import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/loader_spinner.dart';
import 'package:silkeborgbeachvolley/ui/ranking/detail/ranking_detail_matches_row.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_match_data.dart';

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
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int position) {
              RankingMatchData item = snapshot.data[position];
              return Card(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child:
                                Text(DateTimeHelpers.ddMMyyyy(item.matchDate)),
                          ),
                        ],
                      ),
                      RankingMatchesRow(
                        winnerId: item.winner1.id,
                        loserId: item.loser1.id,
                        userId: userId,
                        winnerName: item.winner1.name,
                        winnerPhotoUrl: item.winner1.photoUrl,
                        loserName: item.loser1.name,
                        loserPhotoUrl: item.loser1.photoUrl,
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      RankingMatchesRow(
                        winnerId: item.winner2.id,
                        loserId: item.loser2.id,
                        userId: userId,
                        winnerName: item.winner2.name,
                        winnerPhotoUrl: item.winner2.photoUrl,
                        loserName: item.loser2.name,
                        loserPhotoUrl: item.loser2.photoUrl,
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
}
