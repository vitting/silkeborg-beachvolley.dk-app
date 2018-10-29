import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_theme.dart';
import 'package:silkeborgbeachvolley/ui/helpers/list_item_card_widget.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_widget.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_match_data.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_matches_header_widget.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_matches_stat_row_widget.dart';
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
        if (snapshot.hasError) {
          print(
              "ERROR ranking_detail_matches_main FutureBuilder: ${snapshot.error}");
          return Container();
        }
        if (!snapshot.hasData) return LoaderSpinner();
        if (snapshot.hasData && snapshot.data.length == 0) {
          return Center(
            child: Text(FlutterI18n.translate(context, "ranking.rankingDetailMatchesMain.string1")),
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
                                  message: FlutterI18n.translate(context, "ranking.rankingDetailMatchesMain.string2"),
                                  child: Icon(Icons.calendar_today, size: 12.0),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text(
                                      DateTimeHelpers.dMMyyyy(context, item.matchDate)),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () async {
                                await rankingDetailFunctions.showMatchInfo(
                                    context, item, userId);
                              },
                              color: SilkeborgBeachvolleyTheme.buttonTextColor,
                              icon: Icon(Icons.info_outline),
                            )
                          ],
                        ),
                      ),
                      RankingMatchesHeader(),
                      RankingMatchesStatRow(
                        winner: item.winner1,
                        loser: item.loser1,
                        userId: userId,
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      RankingMatchesStatRow(
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
