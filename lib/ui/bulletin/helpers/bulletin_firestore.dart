import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_comment_item_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_item_data_class.dart';

class BulletinFirestore {
  static final _bulletinCollectionName = "bulletins";
  static final _bulletinCommentsCollectionName = "bulletins_comments";
  static Firestore _firestore;

  static Firestore get firestoreInstance {
    if (_firestore == null) {
      _firestore = Firestore.instance;
    }

    return _firestore;
  }

  static Stream<QuerySnapshot> getAllBulletinComments(String commentsId) {
    return firestoreInstance.collection(_bulletinCommentsCollectionName).where(
        "id",
        isEqualTo: commentsId
      ).snapshots();
  }

  static Future<void> saveCommentItem(BulletinCommentItem bulletinCommentItem) async {
    try {
      return await firestoreInstance.collection(_bulletinCommentsCollectionName).add(bulletinCommentItem.toMap());
    } catch (e) {
      print(e);
    }
  }

 static Stream<QuerySnapshot> getBulletinsByTypeAsStream(String type) {
    return firestoreInstance.collection(_bulletinCollectionName).where(
        "type",
        isEqualTo: type
      ).snapshots();
  }

  static Stream<QuerySnapshot> getAllBulletinsAsStream() {
    return firestoreInstance.collection(_bulletinCollectionName).where(
        "type",
        isEqualTo: "news"
      ).snapshots();
  }

  static Future<void> saveBulletinItem(BulletinItemData bulletinItem) async {
    
    try {
      return await firestoreInstance
        .collection(_bulletinCollectionName).document(bulletinItem.id).setData(bulletinItem.toMap());  
    } catch (e) {
      print(e);
    }
  }

  static Future<void> updateBulletinItem(BulletinItemData bulletinItem) async {
    try {
      return await firestoreInstance
        .collection(_bulletinCollectionName)
        .document(bulletinItem.id)
        .updateData(bulletinItem.toMap());  
    } catch (e) {
      print(e);
    }
  }
}
