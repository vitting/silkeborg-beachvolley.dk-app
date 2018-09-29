import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/detailItem/comment_item_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/playItem/player_committed_data_class.dart';

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

  static Stream<QuerySnapshot> getAllBulletinCommentsAsStream(
      String commentsId) {
    return firestoreInstance
        .collection(_bulletinCommentsCollectionName)
        .where("id", isEqualTo: commentsId)
        .orderBy("creationDate", descending: false)
        .snapshots();
  }

  static Future<void> saveCommentItem(
      BulletinCommentItem bulletinCommentItem) async {
    return await firestoreInstance
        .collection(_bulletinCommentsCollectionName)
        .add(bulletinCommentItem.toMap());
  }

  static Future<void> deleteComment(String id) async {
    return await firestoreInstance
        .collection(_bulletinCommentsCollectionName)
        .document(id)
        .delete();
  }

  static Future<Null> deleteCommentsByBulletinId(String bulletinId) async {
    QuerySnapshot snapshot = await firestoreInstance
        .collection(_bulletinCommentsCollectionName)
        .where("id", isEqualTo: bulletinId)
        .getDocuments();
    WriteBatch batch = firestoreInstance.batch();
    snapshot.documents.forEach((DocumentSnapshot snap) {
      batch.delete(snap.reference);
    });

    return batch.commit();
  }

  static Stream<QuerySnapshot> getBulletinsByTypeAsStream(String type) {
    return firestoreInstance
        .collection(_bulletinCollectionName)
        .where("type", isEqualTo: type)
        .orderBy("creationDate", descending: true)
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

  static Future<void> deleteBulletinItem(String id) async {
    return await firestoreInstance
        .collection(_bulletinCollectionName)
        .document(id)
        .delete();
  }

  static Future<void> addUserHidesBulletinItem(
      String bulletId, String userId) async {
    return await firestoreInstance
        .collection(_bulletinCollectionName)
        .document(bulletId)
        .updateData({
      "hiddenByUser": FieldValue.arrayUnion(userId)
    });
  }

    static Future<void> removeUserHidesBulletinItem(
      String bulletId, String userId) async {
    return await firestoreInstance
        .collection(_bulletinCollectionName)
        .document(bulletId)
        .updateData({
      "hiddenByUser": FieldValue.arrayRemove(userId)
    });
  }

  static Future<void> savePlayerCommitted(
      PlayerCommittedData playerCommitted) async {
    return await firestoreInstance
        .collection(_bulletinPlayersCommittedCollectionName)
        .add(playerCommitted.toMap());
  }

  static Future<void> deletePlayerCommitted(
      String bulletinId, String userId) async {
    QuerySnapshot snapshot = await firestoreInstance
        .collection(_bulletinPlayersCommittedCollectionName)
        .where("bulletinId", isEqualTo: bulletinId)
        .where("userId", isEqualTo: userId)
        .getDocuments();

    snapshot.documents.forEach((DocumentSnapshot doc) {
      firestoreInstance
          .collection(_bulletinPlayersCommittedCollectionName)
          .document(doc.documentID)
          .delete();
    });
  }

  static Future<Null> deletePlayersCommittedByBulletinId(
      String bulletinId) async {
    QuerySnapshot snapshot = await firestoreInstance
        .collection(_bulletinPlayersCommittedCollectionName)
        .where("bulletinId", isEqualTo: bulletinId)
        .getDocuments();
    WriteBatch batch = firestoreInstance.batch();
    snapshot.documents.forEach((DocumentSnapshot snap) {
      batch.delete(snap.reference);
    });

    return batch.commit();
  }

  static Future<QuerySnapshot> getPlayersCommitted(String bulletinId) async {
    return firestoreInstance
        .collection(_bulletinPlayersCommittedCollectionName)
        .where("bulletinId", isEqualTo: bulletinId)
        .getDocuments();
  }

  static Future<bool> checkIfPlayerIsCommited(
      String bulletinId, String userId) async {
    QuerySnapshot snapshot = await firestoreInstance
        .collection(_bulletinPlayersCommittedCollectionName)
        .where("bulletinId", isEqualTo: bulletinId)
        .where("userId", isEqualTo: userId)
        .getDocuments();
    if (snapshot.documents.length != 0) return true;
    return false;
  }

  static Future<DocumentSnapshot> getBulletinItem(String bulletinId) async {
    return await firestoreInstance
        .collection(_bulletinCollectionName)
        .document(bulletinId)
        .get();
  }
}
