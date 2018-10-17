import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_widget.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_firestore.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_match_data.dart';
import 'package:silkeborgbeachvolley/ui/ranking/main/list_of_matches/helpers/ranking_matches_row_widget.dart';

class AdminRankingMatches extends StatefulWidget {
  final String userId;
  
  const AdminRankingMatches({Key key, this.userId}) : super(key: key);

  @override
  AdminRankingMatchesState createState() {
    return new AdminRankingMatchesState();
  }
}

class AdminRankingMatchesState extends State<AdminRankingMatches> {
  final int _numberOfItemsToLoadDefault = 20;
  int _listNumberOfItemsToLoad = 20;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: RankingFirestore.getMatchesAsStream(_listNumberOfItemsToLoad),
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
              userId: widget.userId,
            );
          },
        ),
      ),
    );
  }
}
