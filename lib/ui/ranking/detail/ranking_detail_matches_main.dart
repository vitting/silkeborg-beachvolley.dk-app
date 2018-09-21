import 'dart:async';

import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/loader_spinner.dart';
import 'package:silkeborgbeachvolley/ui/ranking/detail/ranking_detail_matches_header.dart';
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
            itemCount: snapshot.data.length + 1,
            itemBuilder: (BuildContext context, int position) {
              if (position == 0) return RankingDetailMatchesHeader();

              RankingMatchData item = snapshot.data[position - 1];
              //Vi skal lave en detail for match. Så man kan se hvilke point de fik
              //Ellers så skal det stå i row'en, men hvordan laver vi det pænt
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
}
