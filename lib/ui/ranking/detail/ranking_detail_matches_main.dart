import 'dart:async';

import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/list_item_card_widget.dart';
import 'package:silkeborgbeachvolley/helpers/loader_spinner.dart';
import 'package:silkeborgbeachvolley/ui/ranking/detail/ranking_detail_matches_header.dart';
import 'package:silkeborgbeachvolley/ui/ranking/detail/ranking_detail_matches_row.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_match_data.dart';
import './ranking_detail_functions.dart' as rankingDetailFunctions;

class RankingDetailMatches extends StatelessWidget {
  final Future<List<RankingMatchData>> matches;
  final String userId;
  const RankingDetailMatches({Key key, this.matches, this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _main();
  }

  Widget _main() {
    return FutureBuilder(
      future: matches,
      builder: (BuildContext context,
          AsyncSnapshot<List<RankingMatchData>> snapshot) {
        if (!snapshot.hasData) return LoaderSpinner();
        if (snapshot.hasData && snapshot.data.length == 0) {
          return Center(
            child: Text("Kan ikke vise spillede kampe"),
          );
        }
        return Container(
          constraints: BoxConstraints.expand(),
          child: Scrollbar(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int position) {
                RankingMatchData item = snapshot.data[position];
                return ListItemCard(
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
                              await rankingDetailFunctions.showMatchInfo(
                                  context, item, userId);
                            },
                            color: Colors.deepOrange[700],
                            icon: Icon(Icons.info_outline),
                          )
                        ],
                      ),
                      RankingDetailMatchesHeader(),
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
                );
              },
            ),
          ),
        );
      },
    );
  }
}
