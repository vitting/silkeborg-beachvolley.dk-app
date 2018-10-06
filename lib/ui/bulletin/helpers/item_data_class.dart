import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_committed_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_firestore.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';

class BulletinItemData {
  String id;
  BulletinType type;
  String body;
  dynamic creationDate;
  String authorId;
  String authorName;
  String authorPhotoUrl;
  int numberOfcomments;
  List<dynamic> hiddenByUser;
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
      this.hiddenByUser, this.numberOfCommits = 0});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "type": BulletinTypeHelper.getBulletinTypeAsString(type),
      "body": body,
      "creationDate": creationDate == null ? DateTime.now() : creationDate,
      "author": {
        "id": authorId,
        "name": authorName,
        "photoUrl": authorPhotoUrl
      },
      "numberOfcomments": numberOfcomments,
      "numberOfCommits": numberOfCommits,
      "hiddenByUser": hiddenByUser ?? []
    };
  }

  Future<void> hide() {
    return BulletinFirestore.addUserHidesBulletinItem(id, Home.loggedInUser.uid);
  }

  Future<void> unhide() {
    return BulletinFirestore.removeUserHidesBulletinItem(id, Home.loggedInUser.uid);
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

  Future<Null> deleteComments() async {
    return BulletinFirestore.deleteCommentsByBulletinId(id);
  }

  Stream<QuerySnapshot> getCommentsAsStream() {
    return BulletinFirestore.getAllBulletinCommentsAsStream(id);
  }

  String get creationDateFormatted {
    if (creationDate is DateTime) {
      return DateTimeHelpers.ddmmyyyyHHnn(creationDate);
    }

    return "";
  }

  // Future<int> getUpdatedNumberOfCommittedCount() async {
  //   DocumentSnapshot snapshot = await BulletinFirestore.getBulletinItem(id);
  //   if (snapshot.exists) {
  //     numberOfPlayersCommitted = snapshot.data["numberOfPlayersCommitted"];
  //   }

  //   return numberOfPlayersCommitted;
  // }

  Future<List<CommittedData>> getCommitted() async {
    QuerySnapshot data = await BulletinFirestore.getCommitted(id);

    return data.documents.map<CommittedData>((DocumentSnapshot doc) {
      return CommittedData.fromMap(doc.data);
    }).toList();
  }

  Future<bool> isCommitted() async {
    return BulletinFirestore.checkIsCommited(
        id, Home.loggedInUser.uid);
  }

  Future<void> setAsCommitted() async {
    CommittedData playerCommitted = CommittedData(
        bulletinId: id,
        name: Home.loggedInUser.displayName,
        photoUrl: Home.loggedInUser.photoUrl,
        userId: Home.loggedInUser.uid,
        type: type
      );

    return BulletinFirestore.saveCommitted(playerCommitted);
  }

  Future<void> setAsUnCommitted() async {
    return BulletinFirestore.deleteCommitted(id, authorId);
  }

  Future<Null> deleteCommitted() async {
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
        numberOfCommits: item["numberOfCommits"] ?? 0,
        hiddenByUser: item["hiddenByUser"] ?? []);
  }
}
