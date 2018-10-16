import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silkeborgbeachvolley/ui/tournament_calendar/helpers/torunament_data.dart';

class TournamentFirestore {
  static final _collectionName = "tournaments";
  static Firestore _firestore;

  static Firestore get firestoreInstance {
    if (_firestore == null) {
      _firestore = Firestore.instance;
    }

    return _firestore;
  }

  static Future<QuerySnapshot> getTournaments() {
    return firestoreInstance
        .collection(_collectionName)
        .orderBy("startDate")
        .getDocuments();
  }

  static Future<void> saveTournament(TournamentData tournament) {
    return firestoreInstance
        .collection(_collectionName)
        .document(tournament.id)
        .setData(tournament.toMap());
  }

  static Future<void> deleteTournament(String tournamentId) {
    return firestoreInstance
        .collection(_collectionName)
        .document(tournamentId)
        .delete();
  }
}
