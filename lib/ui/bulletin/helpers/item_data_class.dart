import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_firestore.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';

class BulletinItemData {
  String id;
  BulletinType type;
  String body;
  dynamic creationDate;
  String authorId;
  String authorName;
  String authorPhotoUrl;
  int numberOfcomments;
  
  BulletinItemData(
      {this.id = "",
      this.type = BulletinType.none,
      this.body = "",
      this.creationDate,
      this.authorId = "",
      this.authorName = "",
      this.authorPhotoUrl = "",
      this.numberOfcomments = 0});

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
      "numberOfcomments": numberOfcomments
    };
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
    await BulletinFirestore.deleteCommentsByBulletinId(id);
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
  
  static BulletinItemData fromMap(Map<String, dynamic> item) {
    return new BulletinItemData(
        id: item["id"] == null ? "" : item["id"],
        type: BulletinTypeHelper.getBulletinTypeStringAsType(item["type"]),
        authorId: item["author"]["id"] == null ? "" : item["author"]["id"],
        authorName:
            item["author"]["name"] == null ? "" : item["author"]["name"],
        authorPhotoUrl: item["author"]["photoUrl"] == null
            ? ""
            : item["author"]["photoUrl"],
        body: item["body"] == null ? "" : item["body"],
        creationDate: item["creationDate"] == null ? "" : item["creationDate"],
        numberOfcomments:
            item["numberOfcomments"] == null ? 0 : item["numberOfcomments"]);
  }
}
