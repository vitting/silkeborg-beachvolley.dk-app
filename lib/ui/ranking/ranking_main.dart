import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_data.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_sharedpref.dart';
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
          RankingSharedPref.setIsItFirsttime(true);
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
              RankingItem(
                player: RankingPlayerData(
                    name: "Christian Nicolaisen",
                    numberOfPlayedMatches: 22,
                    photoUrl:
                        "https://graph.facebook.com/127462958207239/picture",
                    points: 234,
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
                    numberOfPlayedMatches: 22,
                    photoUrl:
                        "https://graph.facebook.com/127462958207239/picture",
                    points: 234,
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
                    numberOfPlayedMatches: 22,
                    photoUrl:
                        "https://graph.facebook.com/127462958207239/picture",
                    points: 234,
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
                    numberOfPlayedMatches: 22,
                    photoUrl:
                        "https://graph.facebook.com/127462958207239/picture",
                    points: 234,
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
