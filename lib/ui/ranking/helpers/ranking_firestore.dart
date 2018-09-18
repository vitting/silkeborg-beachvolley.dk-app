import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_match_data.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_data.dart';
import 'package:faker/faker.dart';

class RankingFirestore {
  static Firestore _firestore;
  static final _collectionNamePlayer = "ranking_players";
  static final _collectionNameMatch = "ranking_matches";

  static Firestore get firestoreInstance {
    if (_firestore == null) {
      _firestore = Firestore.instance;
    }

    return _firestore;
  }

  static Future<List<DocumentSnapshot>> getPlayerMatches(String userId) async {
    List<DocumentSnapshot> list = [];
    QuerySnapshot winner1 = await firestoreInstance
        .collection(_collectionNameMatch)
        .where("winner1.id", isEqualTo: userId)
        .orderBy("matchDate")
        .getDocuments();
    QuerySnapshot winner2 = await firestoreInstance
        .collection(_collectionNameMatch)
        .where("winner2.id", isEqualTo: userId)
        .orderBy("matchDate")
        .getDocuments();
    QuerySnapshot loser1 = await firestoreInstance
        .collection(_collectionNameMatch)
        .where("loser1.id", isEqualTo: userId)
        .orderBy("matchDate")
        .getDocuments();
    QuerySnapshot loser2 = await firestoreInstance
        .collection(_collectionNameMatch)
        .where("loser2.id", isEqualTo: userId)
        .orderBy("matchDate")
        .getDocuments();
  
    list.addAll(winner1.documents);
    list.addAll(winner2.documents);
    list.addAll(loser1.documents);
    list.addAll(loser2.documents);

    return list;
  }

  static Stream<QuerySnapshot> getRanking() {
    return firestoreInstance
        .collection(_collectionNamePlayer)
        .orderBy("points.total", descending: true)
        .orderBy("numberOfPlayedMatches.total", descending: true)
        .snapshots();
  }

  static Future<DocumentSnapshot> getMatch(String matchId) async {
    return firestoreInstance
        .collection(_collectionNameMatch)
        .document(matchId)
        .get();
  }

  static Future<void> saveMatch(RankingMatchData match) async {
    return firestoreInstance
        .collection(_collectionNameMatch)
        .document()
        .setData(match.toMap());
  }

  static Future<QuerySnapshot> getAllPlayers() {
    return firestoreInstance
        .collection(_collectionNamePlayer)
        .orderBy("name")
        .getDocuments();
  }

  static Future<DocumentSnapshot> getPlayer(String userId) async {
    return firestoreInstance
        .collection(_collectionNamePlayer)
        .document(userId)
        .get();
  }

  static Future<void> savePlayer(RankingPlayerData player) async {
    return firestoreInstance
        .collection(_collectionNamePlayer)
        .document(player.userId)
        .setData(player.toMap());
  }

//CHRISTIAN: Only for testing
  static createFakePlayers(int numberToCreate) async {
    Faker faker = Faker();

    for (var i = 0; i < numberToCreate; i++) {
      int pWon = faker.randomGenerator.integer(300);
      int pLost = faker.randomGenerator.integer(300);
      int pTotal = pWon + pLost;
      int nWon = faker.randomGenerator.integer(30);
      int nLost = faker.randomGenerator.integer(30);
      int nTotal = nWon + nLost;
      RankingPlayerData data = new RankingPlayerData(
        name: faker.person.name(),
        numberOfPlayedMatches:
            RankingPlayerDataStats(total: nTotal, won: nWon, lost: nLost),
        photoUrl: "https://placeimg.com/100/100/any",
        points: RankingPlayerDataStats(total: pTotal, won: pWon, lost: pLost),
        sex: faker.randomGenerator.integer(2, min: 0) == 0 ? "male" : "female",
        userId: faker.guid.guid(),
      );
      await savePlayer(data);
    }
  }
}