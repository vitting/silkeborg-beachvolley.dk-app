import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_data.dart';

class RankingFirestore {
  static Firestore _firestore;
  static final _collectionNamePlayer = "ranking_players";

  static Firestore get firestoreInstance {
    if (_firestore == null) {
      _firestore = Firestore.instance;
    }

    return _firestore;
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
}
