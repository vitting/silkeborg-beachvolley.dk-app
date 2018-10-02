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
    _checkIfPlayerExists();
    super.initState();
  }

  void _checkIfPlayerExists() async {
    if (await RankingSharedPref.isItfirstTime()) {
      _showFirstTimeSetup();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
      title: "Ranglisten",
      body: _main(),
      floatingActionButton: FloatingActionButton(
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
    return Container(
        child: Scrollbar(
                  child: ListView(
      children: <Widget>[
          StreamBuilder(
            stream: RankingFirestore.getRanking(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  !snapshot.hasData) return LoaderSpinner();
              int counter = -1;
              return Column(
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
              );
            },
          ),
      ],
    ),
        ));
  }

  _showFirstTimeSetup() async {
    await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              RankingFirstTime(
                onPressedValue: (bool value) {
                  if (value) {
                    RankingSharedPref.setIsItFirsttime(false);
                  }
                },
              )
            ],
          );
        });
  }
}
