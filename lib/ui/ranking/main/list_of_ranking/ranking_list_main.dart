import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_widget.dart';
import 'package:silkeborgbeachvolley/ui/helpers/no_data_widget.dart';
import 'package:silkeborgbeachvolley/ui/ranking/detail/ranking_detail_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_data_class.dart';
import 'package:silkeborgbeachvolley/ui/ranking/main/list_of_ranking/helpers/ranking_item_widget.dart';

class RankingList extends StatefulWidget {
  @override
  _RankingListState createState() => _RankingListState();
}

class _RankingListState extends State<RankingList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: RankingPlayerData.getRankingAsStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print("ERROR ranking_list_main StreamBuilder: ${snapshot.error}");
            return Container();
          }
          if (!snapshot.hasData) return LoaderSpinner();

          if (snapshot.data.documents.length == 0)
            return NoData("Der er pt. ingen personer på ranglisten");

          int counter = -1;
          return Scrollbar(
            child: ListView(
              children:
                  snapshot.data.documents.map<Widget>((DocumentSnapshot doc) {
                RankingPlayerData player = RankingPlayerData.fromMap(doc.data);
                counter++;

                return RankingItem(
                  player: player,
                  showAnimation: counter == 0,
                  position: counter,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (BuildContext context) =>
                                RankingDetail(player)));
                  },
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
