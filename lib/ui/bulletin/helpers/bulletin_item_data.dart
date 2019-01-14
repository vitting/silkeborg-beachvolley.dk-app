import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_committed_data.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_firestore.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';

class BulletinItemData {
  String id;
  BulletinType type;
  String body;
  Timestamp creationDate;
  String authorId;
  String authorName;
  String authorPhotoUrl;
  int numberOfcomments;
  int numberOfCommits;
  BulletinItemData(
      {this.id = "",
      this.type = BulletinType.none,
      this.body = "",
      this.creationDate,
      this.authorId = "",
      this.authorName = "",
      this.authorPhotoUrl = "",
      this.numberOfcomments = 0,
      this.numberOfCommits = 0});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "type": BulletinTypeHelper.getBulletinTypeAsString(type),
      "body": body,
      "creationDate": creationDate,
      "author": {
        "id": authorId,
        "name": authorName,
        "photoUrl": authorPhotoUrl
      },
      "numberOfcomments": numberOfcomments,
      "numberOfCommits": numberOfCommits
    };
  }

  Future<void> hide(String userId) {
    return BulletinFirestore.addUserHidesBulletinItem(id, userId);
  }

  Future<void> unhide(String userId) {
    return BulletinFirestore.removeUserHidesBulletinItem(id, userId);
  }

  ///Deletes all images, comments and the news item.
  Future<bool> delete() async {
    try {
      await deleteComments();
      await BulletinFirestore.deleteBulletinItem(id);
      return true;
    } catch (e) {
      print("BulletinItemData - delete() : $e");
      return false;
    }
  }

  Future<void> deleteComments() async {
    return BulletinFirestore.deleteCommentsByBulletinId(id);
  }

  Stream<QuerySnapshot> getCommentsAsStream(int limit) {
    return BulletinFirestore.getAllBulletinCommentsAsStream(id, limit);
  }

  String get creationDateFormatted {
    return DateTimeHelpers.ddmmyyyyHHnn(creationDate.toDate());
  }

  Future<List<CommittedData>> getCommitted() async {
    QuerySnapshot data = await BulletinFirestore.getCommitted(id);

    return data.documents.map<CommittedData>((DocumentSnapshot doc) {
      return CommittedData.fromMap(doc.data);
    }).toList();
  }

  Future<bool> isCommitted(String userId) async {
    return BulletinFirestore.checkIsCommited(id, userId);
  }

  Future<void> setAsCommitted(FirebaseUser user) async {
    CommittedData playerCommitted = CommittedData(
        bulletinId: id,
        name: user.displayName,
        photoUrl: user.photoUrl,
        userId: user.uid,
        type: type);

    return BulletinFirestore.saveCommitted(playerCommitted);
  }

  Future<void> setAsUnCommitted() async {
    return BulletinFirestore.deleteCommitted(id, authorId);
  }

  Future<void> deleteCommitted() async {
    return BulletinFirestore.deleteCommittedByBulletinId(id);
  }

  factory BulletinItemData.fromMap(Map<String, dynamic> item) {
    return new BulletinItemData(
        id: item["id"] ?? "",
        type: BulletinTypeHelper.getBulletinTypeStringAsType(item["type"]),
        authorId: item["author"]["id"] ?? "",
        authorName: item["author"]["name"] ?? "",
        authorPhotoUrl: item["author"]["photoUrl"] ?? "",
        body: item["body"] ?? "",
        creationDate: item["creationDate"],
        numberOfcomments: item["numberOfcomments"] ?? 0,
        numberOfCommits: item["numberOfCommits"] ?? 0);
  }
}
