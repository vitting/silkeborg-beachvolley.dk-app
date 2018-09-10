import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/detailItem/comment_item_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/playItem/player_committed_class.dart';

class BulletinFirestore {
  static final _bulletinCollectionName = "bulletins";
  static final _bulletinCommentsCollectionName = "bulletins_comments";
  static final _bulletinPlayersCommittedCollectionName =
      "bulletins_players_committed";
  static Firestore _firestore;

  static Firestore get firestoreInstance {
    if (_firestore == null) {
      _firestore = Firestore.instance;
    }

    return _firestore;
  }

  static Stream<QuerySnapshot> getAllBulletinComments(String commentsId) {
    return firestoreInstance
        .collection(_bulletinCommentsCollectionName)
        .where("id", isEqualTo: commentsId)
        .snapshots();
  }

  static Future<void> saveCommentItem(
      BulletinCommentItem bulletinCommentItem) async {
    return await firestoreInstance
          .collection(_bulletinCommentsCollectionName)
          .add(bulletinCommentItem.toMap());
  }

  static Stream<QuerySnapshot> getBulletinsByTypeAsStream(String type) {
    return firestoreInstance
        .collection(_bulletinCollectionName)
        .where("type", isEqualTo: type)
        .snapshots();
  }

  static Stream<QuerySnapshot> getAllBulletinsAsStream() {
    return firestoreInstance
        .collection(_bulletinCollectionName)
        .where("type", isEqualTo: "news")
        .snapshots();
  }

  static Future<void> saveBulletinItem(BulletinItemData bulletinItem) async {
    await firestoreInstance
          .collection(_bulletinCollectionName)
          .document(bulletinItem.id)
          .setData(bulletinItem.toMap());
  }

  static Future<void> updateBulletinItem(BulletinItemData bulletinItem) async {
    return await firestoreInstance
          .collection(_bulletinCollectionName)
          .document(bulletinItem.id)
          .updateData(bulletinItem.toMap());
  }

  static Future<void> savePlayerCommitted(
      PlayerCommitted playerCommitted) async {
    return await firestoreInstance
          .collection(_bulletinPlayersCommittedCollectionName)
          .add(playerCommitted.toMap());
  }

  static Future<void> deletePlayerCommitted(String bulletinId, String userId) async {
    QuerySnapshot snapshot = await firestoreInstance
          .collection(_bulletinPlayersCommittedCollectionName).where("bulletinId", isEqualTo: bulletinId).where("userId", isEqualTo: userId).getDocuments();

    snapshot.documents.forEach((DocumentSnapshot doc) {
      firestoreInstance.collection(_bulletinPlayersCommittedCollectionName).document(doc.documentID).delete();
    });
  }

  static Stream<QuerySnapshot> getPlayersCommittedAsStream(String bulletinId) {
    return firestoreInstance
        .collection(_bulletinPlayersCommittedCollectionName)
        .where("bulletinId", isEqualTo: bulletinId)
        .snapshots();
  }

  static Future<bool> checkIfPlayerIsCommited(String bulletinId, String userId) async {
    QuerySnapshot snapshot = await firestoreInstance.collection(_bulletinPlayersCommittedCollectionName).where("bulletinId", isEqualTo: bulletinId).where("userId", isEqualTo: userId).getDocuments();
    if (snapshot.documents.length != 0) return true;
    return false;
  }
}
