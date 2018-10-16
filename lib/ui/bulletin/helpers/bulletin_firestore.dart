import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_committed_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/detailItem/bulletin_comment_item_data.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/item_data_class.dart';

class BulletinFirestore {
  static final _bulletinCollectionName = "bulletins";
  static final _bulletinCommentsCollectionName = "bulletins_comments";
  static final _bulletinCommittedCollectionName = "bulletins_commits";
  static final _bulletinHiddenByUserCollectionName = "bulletins_hidden_by_user";
  static Firestore _firestore;

  static Firestore get firestoreInstance {
    if (_firestore == null) {
      _firestore = Firestore.instance;
    }

    return _firestore;
  }

  static Stream<QuerySnapshot> getAllBulletinCommentsAsStream(
      String bulletinId) {
    return firestoreInstance
        .collection(_bulletinCommentsCollectionName)
        .where("bulletinId", isEqualTo: bulletinId)
        .orderBy("creationDate", descending: false)
        .snapshots();
  }

  static Future<void> saveCommentItem(
      BulletinCommentItemData bulletinCommentItem) async {
    return firestoreInstance
        .collection(_bulletinCommentsCollectionName)
        .document(bulletinCommentItem.id)
        .setData(bulletinCommentItem.toMap());
  }

  static Future<void> deleteComment(String id) async {
    return firestoreInstance
        .collection(_bulletinCommentsCollectionName)
        .document(id)
        .delete();
  }

  static Future<Null> deleteCommentsByBulletinId(String bulletinId) async {
    QuerySnapshot snapshot = await firestoreInstance
        .collection(_bulletinCommentsCollectionName)
        .where("bulletinId", isEqualTo: bulletinId)
        .getDocuments();
    WriteBatch batch = firestoreInstance.batch();
    snapshot.documents.forEach((DocumentSnapshot snap) {
      batch.delete(snap.reference);
    });

    return batch.commit();
  }

  static Stream<QuerySnapshot> getBulletinsByTypeAsStream(
      BulletinType type, int limit) {
    return firestoreInstance
        .collection(_bulletinCollectionName)
        .where("type",
            isEqualTo: BulletinTypeHelper.getBulletinTypeAsString(type))
        .orderBy("creationDate", descending: true)
        .limit(limit)
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

  static Future<List<String>> getHiddenBulletinItems(String userId) async {
    List<String> ids = [];
    DocumentSnapshot doc = await firestoreInstance
        .collection(_bulletinHiddenByUserCollectionName)
        .document(userId)
        .get();
    if (doc.exists) {
      ids = (doc.data["ids"] as List<dynamic>).map<String>((dynamic id) {
        return id;
      }).toList();
    }

    return ids;
  }

  static Future<void> addUserHidesBulletinItem(
      String bulletId, String userId) async {
    return await firestoreInstance
        .collection(_bulletinHiddenByUserCollectionName)
        .document(userId)
        .setData({
      "ids": FieldValue.arrayUnion([bulletId])
    }, merge: true);
  }

  static Future<void> removeUserHidesBulletinItem(
      String bulletId, String userId) async {
    return await firestoreInstance
        .collection(_bulletinHiddenByUserCollectionName)
        .document(userId)
        .setData({
      "ids": FieldValue.arrayRemove([bulletId])
    }, merge: true);
  }

  static Future<void> saveCommitted(CommittedData playerCommitted) async {
    return await firestoreInstance
        .collection(_bulletinCommittedCollectionName)
        .add(playerCommitted.toMap());
  }

  static Future<void> deleteCommitted(String bulletinId, String userId) async {
    QuerySnapshot snapshot = await firestoreInstance
        .collection(_bulletinCommittedCollectionName)
        .where("bulletinId", isEqualTo: bulletinId)
        .where("userId", isEqualTo: userId)
        .getDocuments();

    snapshot.documents.forEach((DocumentSnapshot doc) {
      firestoreInstance
          .collection(_bulletinCommittedCollectionName)
          .document(doc.documentID)
          .delete();
    });
  }

  static Future<Null> deleteCommittedByBulletinId(String bulletinId) async {
    QuerySnapshot snapshot = await firestoreInstance
        .collection(_bulletinCommittedCollectionName)
        .where("bulletinId", isEqualTo: bulletinId)
        .getDocuments();
    WriteBatch batch = firestoreInstance.batch();
    snapshot.documents.forEach((DocumentSnapshot snap) {
      batch.delete(snap.reference);
    });

    return batch.commit();
  }

  static Future<QuerySnapshot> getCommitted(String bulletinId) async {
    return firestoreInstance
        .collection(_bulletinCommittedCollectionName)
        .where("bulletinId", isEqualTo: bulletinId)
        .getDocuments();
  }

  static Future<bool> checkIsCommited(String bulletinId, String userId) async {
    QuerySnapshot snapshot = await firestoreInstance
        .collection(_bulletinCommittedCollectionName)
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
