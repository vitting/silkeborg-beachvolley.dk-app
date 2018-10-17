import 'dart:async';

import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/ui/helpers/list_item_card_widget.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_widget.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_match_data.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_matches_header_widget.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_matches_row_widget.dart';
import './helpers/ranking_detail_functions.dart' as rankingDetailFunctions;

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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Tooltip(
                                  message: "Kamp dato",
                                  child: Icon(Icons.calendar_today, size: 12.0),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text(
                                      DateTimeHelpers.dMMyyyy(item.matchDate)),
                                ),
                              ],
                            ),
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
                      ),
                      RankingMatchesHeader(),
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
