import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/loader_spinner.dart';
import 'package:silkeborgbeachvolley/ui/ranking/detail/ranking_detail_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_firestore.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_data_class.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_sharedpref.dart';
import 'package:silkeborgbeachvolley/ui/ranking/createMatch/ranking_create_match_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/main/ranking_firsttime_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/main/ranking_item.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/silkeborgBeachvolleyScaffold.dart';

class Ranking extends StatefulWidget {
  static final String routeName = "/ranking";
  @override
  _RankingState createState() => _RankingState();
}

class _RankingState extends State<Ranking> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _checkIfPlayerExists(context));
  }

  void _checkIfPlayerExists(BuildContext context) async {
    if (await RankingSharedPref.isItfirstTime()) {
      _showFirstTimeSetup(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
      title: "Ranglisten",
      body: _main(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange[700],
        tooltip: "Registere kamp",
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => RankingCreateMatch(),
              fullscreenDialog: true));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _main() {
    // RankingFirestore.createFakeMatches(50);
    return Container(
      child: StreamBuilder(
        stream: RankingFirestore.getRanking(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return LoaderSpinner();

          if (snapshot.data.documents.length == 0) {
            return Center(
                child: Text("Der er pt. ingen personer på ranglisten"));
          }
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

  _showFirstTimeSetup(BuildContext context) async {
    await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              RankingFirstTime(
                onPressedValue: (bool value) async {
                  if (value) {
                    await RankingSharedPref.setIsItFirsttime(false);
                  }
                },
              )
            ],
          );
        });
  }
}
