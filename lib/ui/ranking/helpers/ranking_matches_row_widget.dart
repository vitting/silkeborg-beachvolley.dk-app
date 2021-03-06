import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_theme.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_match_data.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_matches_row_element_widget.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_data_class.dart';

class RankingMatchesRow extends StatelessWidget {
  static Map<String, String> _cachedData = Map<String, String>();
  final RankingMatchData match;
  final String userId;
  final IconData icon;
  final ValueChanged<RankingMatchData> iconOnTap;

  const RankingMatchesRow(
      {Key key,
      @required this.match,
      @required this.userId,
      this.icon,
      this.iconOnTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 3.0),
                    child: Row(
                      children: <Widget>[
                        Tooltip(
                          message: FlutterI18n.translate(context,
                              "ranking.rankingMatchesRowWidget.string1"),
                          child: Icon(Icons.calendar_today,
                              size: 12.0, color: Colors.black),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text(
                              DateTimeHelpers.dMMyyyy(context, match.matchDate),
                              style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                  ),
                  icon == null
                      ? Container()
                      : IconButton(
                          icon: Icon(icon),
                          onPressed: () {
                            iconOnTap(match);
                          },
                          color: SilkeborgBeachvolleyTheme.buttonTextColor,
                        )
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        RankingMatchesRowElement(
                            name: match.winner1.name,
                            points: match.winner1.points,
                            photoUrl: match.winner1.photoUrl,
                            backgroundColor: Colors.blue[700]),
                        RankingMatchesRowElement(
                            name: match.winner2.name,
                            points: match.winner2.points,
                            photoUrl: match.winner2.photoUrl,
                            backgroundColor: Colors.blue[700])
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 3.0),
                    child: Column(
                      children: <Widget>[
                        RankingMatchesRowElement(
                            name: match.loser1.name,
                            points: match.loser1.points,
                            photoUrl: match.loser1.photoUrl,
                            backgroundColor: Colors.blue),
                        RankingMatchesRowElement(
                            name: match.loser2.name,
                            points: match.loser2.points,
                            photoUrl: match.loser2.photoUrl,
                            backgroundColor: Colors.blue)
                      ],
                    ),
                  ),
                )
              ],
            ),
            _createdByPlayer(context)
          ],
        ),
      ),
    );
  }

  Widget _createdByPlayer(BuildContext context) {
    Widget widgets;
    if (RankingMatchesRow._cachedData.containsKey(match.userId)) {
      String playerName = RankingMatchesRow._cachedData[match.userId];
      widgets = _createdByPlayerRow(context, playerName);
    } else {
      widgets = FutureBuilder(
        future: match.getPlayerCreatedMatch(),
        builder:
            (BuildContext context, AsyncSnapshot<RankingPlayerData> player) {
          if (!player.hasData) return Container();

          RankingMatchesRow._cachedData
              .putIfAbsent(match.userId, () => player.data.name);
          return _createdByPlayerRow(context, player.data.name);
        },
      );
    }

    return widgets;
  }

  Widget _createdByPlayerRow(BuildContext context, String name) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
              "${FlutterI18n.translate(context, "ranking.rankingMatchesRowWidget.string2")} $name",
              style: TextStyle(fontSize: 10.0, fontStyle: FontStyle.italic))
        ],
      ),
    );
  }
}
