import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_firestore.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_match_data.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_data.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_sharedpref.dart';
import 'package:silkeborgbeachvolley/ui/ranking/createMatch/ranking_create_match_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/ranking_firsttime_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/ranking_item.dart';
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
            fullscreenDialog: true
          ));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _main() {
    return Container(
      child: RefreshIndicator(
          onRefresh: () {},
          child: ListView(
            children: <Widget>[
              Row(
                children: <Widget>[
          //         RaisedButton(
          //   onPressed: () {
          //     RankingSharedPref.removeIsItFirstTime();
          //   },
          //   child: Text("ResetIsFirstTime"),
          // ),
          // RaisedButton(
          //   onPressed: () {
          //     RankingFirestore.createFakePlayers(20);
          //   },
          //   child: Text("Generate Players"),
          // ),
          // RaisedButton(
          //   onPressed: () async {
          //     DocumentSnapshot refence = await RankingFirestore.getMatch("-LMY7qCKWev5IfhxHU_h");
          //     print(RankingMatchData.fromMap(refence.data));
          //   },
          //   child: Text("Get Match"),
          // )
                ],
              ),
              RankingItem(
                player: RankingPlayerData(
                    name: "Christian Nicolaisen",
                    numberOfPlayedMatches: RankingPlayerDataStats(total: 22, won: 11, lost: 11),
                    photoUrl:
                        "https://graph.facebook.com/127462958207239/picture",
                    points: RankingPlayerDataStats(total: 222, won: 212, lost: 10),
                    sex: "male",
                    userId: "bpxa64leuva3kh8FA7EzQbDBIfr1"),
                onTap: () {
                  print("Tab");
                },
                position: 0,
                showAnimation: true,
              ),
              RankingItem(
                player: RankingPlayerData(
                    name: "Christian Nicolaisen",
                    numberOfPlayedMatches: RankingPlayerDataStats(total: 22, won: 11, lost: 11),
                    photoUrl:
                        "https://graph.facebook.com/127462958207239/picture",
                    points: RankingPlayerDataStats(total: 222, won: 212, lost: 10),
                    sex: "male",
                    userId: "bpxa64leuva3kh8FA7EzQbDBIfr1"),
                onTap: () {
                  print("Tab");
                },
                position: 1,
                showAnimation: false,
              ),
              RankingItem(
                player: RankingPlayerData(
                    name: "Christian Nicolaisen",
                    numberOfPlayedMatches: RankingPlayerDataStats(total: 22, won: 11, lost: 11),
                    photoUrl:
                        "https://graph.facebook.com/127462958207239/picture",
                    points: RankingPlayerDataStats(total: 222, won: 212, lost: 10),
                    sex: "male",
                    userId: "bpxa64leuva3kh8FA7EzQbDBIfr1"),
                onTap: () {
                  print("Tab");
                },
                position: 2,
                showAnimation: false,
              ),
              RankingItem(
                player: RankingPlayerData(
                    name: "Christian Nicolaisen",
                    numberOfPlayedMatches: RankingPlayerDataStats(total: 22, won: 11, lost: 11),
                    photoUrl:
                        "https://graph.facebook.com/127462958207239/picture",
                    points: RankingPlayerDataStats(total: 222, won: 212, lost: 10),
                    sex: "male",
                    userId: "bpxa64leuva3kh8FA7EzQbDBIfr1"),
                onTap: () {
                  print("Tab");
                },
                position: 3,
                showAnimation: false,
              )
            ],
          )),
    );
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
      }
    );
  }
}
