import "package:flutter/material.dart";
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/list_item_card_widget.dart';
import 'package:silkeborgbeachvolley/helpers/loader_spinner.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_match_data.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_matches_header_widget.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_matches_row_widget.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_data_class.dart';

class RankingMatches extends StatelessWidget {
  final Future<List<RankingMatchData>> matches;
  final String userId;
  const RankingMatches({Key key, this.matches, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: matches,
      builder: (BuildContext context,
          AsyncSnapshot<List<RankingMatchData>> snapshot) {
        if (!snapshot.hasData) return LoaderSpinner();
        if (snapshot.hasData && snapshot.data.length == 0) {
          return Card(
            child: Center(
              child: Text("Der blev ikke fundet nogen kampe"),
            ),
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
                            FutureBuilder(
                              future: item.getPlayerCreatedMatch(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<RankingPlayerData> player) {
                                if (!player.hasData) return Container();

                                return Row(
                                  children: <Widget>[
                                    Tooltip(
                                        message: "Oprettet af",
                                        child: const Icon(Icons.create,
                                            size: 10.0)),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 3.0),
                                      child: Text(player.data.name, style: TextStyle(fontSize: 12.0)),
                                    ),
                                  ],
                                );
                              },
                            )
                          ],
                        ),
                      ),
                      RankingMatchesHeader(),
                      RankingMatchesRow(
                        showPoints: true,
                        winner: item.winner1,
                        loser: item.loser1,
                        userId: userId,
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      RankingMatchesRow(
                        showPoints: true,
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
