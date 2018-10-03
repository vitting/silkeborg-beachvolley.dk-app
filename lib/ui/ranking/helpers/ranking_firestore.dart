import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_match_data.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_match_player_data_class.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_data_class.dart';
import 'package:faker/faker.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_stats_data_class.dart';

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

  //CHRISTIAN: If we delete a match, we have to rollback points
  //Maybe only admin can delete a match
  static Future<void> deleteMatch(String id) {
    return firestoreInstance
        .collection(_collectionNameMatch)
        .document(id)
        .delete();
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

  static Future<void> addPlayerAsFavorite(String userId, String favoritePlayerId) {
    return firestoreInstance.collection(_collectionNamePlayer).document(userId).updateData({
      "playerFavorites": FieldValue.arrayUnion([favoritePlayerId])
    });
  }

  static Future<void> removePlayerAsFavorite(String userId, String favoritePlayerId) {
    return firestoreInstance.collection(_collectionNamePlayer).document(userId).updateData({
      "playerFavorites": FieldValue.arrayRemove([favoritePlayerId])
    });
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
            RankingPlayerStatsData(total: nTotal, won: nWon, lost: nLost),
        photoUrl: "https://placeimg.com/100/100/any",
        points: RankingPlayerStatsData(total: pTotal, won: pWon, lost: pLost),
        sex: faker.randomGenerator.integer(2, min: 0) == 0 ? "male" : "female",
        userId: faker.guid.guid(),
      );
      await savePlayer(data);
    }
  }

  static createFakeMatches(int numbertoCreate) async {
    Faker faker = Faker();
    QuerySnapshot playersSnap = await getAllPlayers();
    List<RankingPlayerData> players =
        playersSnap.documents.map<RankingPlayerData>((player) {
      return RankingPlayerData.fromMap(player.data);
    });

    if (players.length < 10)
      throw Exception("Please create more Ranking player");

    for (var i = 0; i < numbertoCreate; i++) {
      RankingPlayerData winner1;
      RankingPlayerData winner2;
      RankingPlayerData loser1;
      RankingPlayerData loser2;
      List<RankingPlayerData> playersCopy =
          players.map((RankingPlayerData data) {
        return data;
      }).toList();

      List<RankingPlayerData> choosenPlayers = [];
      for (var x = 0; x < 4; x++) {
        int playerNumber =
            faker.randomGenerator.integer(playersCopy.length, min: 0);
        RankingPlayerData playerChoosen = playersCopy[playerNumber];
        choosenPlayers.add(playerChoosen);
        playersCopy.remove(playerChoosen);
      }

      winner1 = choosenPlayers[0];
      winner2 = choosenPlayers[1];
      loser1 = choosenPlayers[2];
      loser2 = choosenPlayers[3];
      
      int month = faker.randomGenerator.integer(10, min: 4);
      int day = faker.randomGenerator.integer(30, min: 1);
      DateTime matchDate = DateTime(2018, month, day);
      
      RankingMatchData match = RankingMatchData(
          matchDate: matchDate,
          winner1: RankingMatchPlayerData(
              id: winner1.userId,
              name: winner1.name,
              photoUrl: winner1.photoUrl,
              points: 0),
          winner2: RankingMatchPlayerData(
              id: winner2.userId,
              name: winner2.name,
              photoUrl: winner2.photoUrl,
              points: 0),
          loser1: RankingMatchPlayerData(
              id: loser1.userId,
              name: loser1.name,
              photoUrl: loser1.photoUrl,
              points: 0),
          loser2: RankingMatchPlayerData(
              id: loser2.userId,
              name: loser2.name,
              photoUrl: loser2.photoUrl,
              points: 0)
      );

    await match.save();
    }
  }
}
