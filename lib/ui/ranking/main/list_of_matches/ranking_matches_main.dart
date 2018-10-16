import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:silkeborgbeachvolley/helpers/loader_spinner_widget.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_match_data.dart';
import 'package:silkeborgbeachvolley/ui/ranking/main/list_of_matches/ranking_matches_row_widget.dart';

class RankingMatches extends StatelessWidget {
  final String userId;
  final Stream<QuerySnapshot> matches;
  const RankingMatches({Key key, this.userId, this.matches}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: matches,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return LoaderSpinner();
        if (snapshot.hasData && snapshot.data.documents.length == 0) {
          return Card(
            child: Center(
              child: Text("Der blev ikke fundet nogen kampe"),
            ),
          );
        }
        List<RankingMatchData> list = snapshot.data.documents
            .map<RankingMatchData>((DocumentSnapshot doc) {
          return RankingMatchData.fromMap(doc.data);
        }).toList();

        return _list(context, list);
      },
    );
  }

  Widget _list(BuildContext context, List<RankingMatchData> list) {
    return Container(
      constraints: BoxConstraints.expand(),
      child: Scrollbar(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (BuildContext context, int position) {
            RankingMatchData item = list[position];
            return RankingMatchesRow(
              match: item,
              userId: userId,
            );
          },
        ),
      ),
    );
  }
}
