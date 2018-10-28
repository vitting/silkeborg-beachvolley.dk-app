import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silkeborgbeachvolley/ui/livescore/helpers/livescore_data.dart';
import 'package:silkeborgbeachvolley/ui/livescore/helpers/livescore_sets_played_data.dart';

class LivescoreFirestore {
  static Firestore _firestore = Firestore.instance;
  static final _collectionName = "livescore_matches";

  static Stream<DocumentSnapshot> getMatchAsStream(String id) {
    return _firestore.collection(_collectionName).document(id).snapshots();
  }

  static Stream<QuerySnapshot> getAllUpcomingMatchesAsStream() {
    return _firestore
        .collection(_collectionName)
        .where("active", isNull: true)
        .orderBy("matchDate")
        .snapshots();
  }

  static Stream<QuerySnapshot> getAllStartedMatchesAsStream() {
    return _firestore
        .collection(_collectionName)
        .where("active", isEqualTo: true)
        .orderBy("matchDate")
        .snapshots();
  }

  static Stream<QuerySnapshot> getAllEndedMatchesAsStream() {
    return _firestore
        .collection(_collectionName)
        .where("active", isEqualTo: false)
        .orderBy("matchDate")
        .snapshots();
  }

  static Future<void> saveMatch(LivescoreData livescoreData) {
    return _firestore
        .collection(_collectionName)
        .document(livescoreData.id)
        .setData(livescoreData.toMap());
  }

  static Future<void> deleteMatch(String matchId) {
    return _firestore.collection(_collectionName).document(matchId).delete();
  }

  static Future<void> updateSet(String matchId, int setScore, int team,
      LivescoreSetsPlayedData setPlayed) {
    return _firestore.collection(_collectionName).document(matchId).updateData({
      "setTeam$team": setScore,
      "setsPlayed": FieldValue.arrayUnion([setPlayed.toMap()])
    });
  }

  static Future<void> setPointsTimeouts(String matchId, int pointsTeam1,
      int pointsTeam2, int timeoutsTeam1, int timeoutsTeam2) {
    return _firestore.collection(_collectionName).document(matchId).updateData({
      "pointsTeam1": pointsTeam1,
      "pointsTeam2": pointsTeam2,
      "timeoutsTeam1": timeoutsTeam1,
      "timeoutsTeam2": timeoutsTeam2
    });
  }

  static Future<void> updatePoints(String matchId, int points, int team) {
    return _firestore
        .collection(_collectionName)
        .document(matchId)
        .updateData({"pointsTeam$team": points, "activeTeam": team});
  }

  static Future<void> updateTimeouts(String matchId, int timeouts, int team) {
    return _firestore
        .collection(_collectionName)
        .document(matchId)
        .updateData({"timeoutsTeam$team": timeouts});
  }

  static Future<void> updateMatchAsStarted(
      String matchId, DateTime matchStartedAt, int startTeam) {
    return _firestore.collection(_collectionName).document(matchId).updateData({
      "winnerTeam": null,
      "startTeam": startTeam,
      "activeTeam": startTeam,
      "matchStartedAt": Timestamp.fromDate(matchStartedAt),
      "active": true
    });
  }

  static Future<void> updateMatchAsEnded(
      String matchId, DateTime matchEndedAt, int team) {
    return _firestore.collection(_collectionName).document(matchId).updateData({
      "winnerTeam": team,
      "activeTeam": 0,
      "matchEndedAt": Timestamp.fromDate(matchEndedAt),
      "active": false,
      "pointsTeam1": 0,
      "pointsTeam2": 0,
      "timeoutsTeam1": 0,
      "timeoutsTeam2": 0
    });
  }

  static Future<void> updateMatchMessage(
      String matchId, int message, int matchMessageTeam) {
    return _firestore.collection(_collectionName).document(matchId).updateData(
        {"matchMessage": message, "matchMessageTeam": matchMessageTeam});
  }
}
