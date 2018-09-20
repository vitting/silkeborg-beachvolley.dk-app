import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_firestore.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';

class BulletinCommentItem {
  String id;
  String body;
  dynamic creationDate;
  String authorId;
  String authorName;
  String authorPhotoUrl;
  
  BulletinCommentItem(
      {this.id = "",
      this.body = "",
      this.creationDate,
      this.authorId,
      this.authorName,
      this.authorPhotoUrl});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "body": body,
      "creationDate": creationDate ?? FieldValue.serverTimestamp(),
      "author": {"id": authorId, "name": authorName, "photoUrl": authorPhotoUrl},
    };
  }

  Future<void> save() {
    authorId = authorId ?? Home.loggedInUser.uid;
    authorName = authorName ?? Home.loggedInUser.displayName;
    authorPhotoUrl = authorPhotoUrl ?? Home.loggedInUser.photoUrl;

    return BulletinFirestore.saveCommentItem(this);
  }

  static fromMap(Map<String, dynamic> item) {
    return new BulletinCommentItem(
        id: item["id"] ?? "",
        body: item["body"] ?? "",
        creationDate: item["creationDate"] ?? DateTime.now(),
        authorId: item["author"]["id"] ?? "",
        authorName: item["author"]["name"]?? "",
        authorPhotoUrl: item["author"]["photoUrl"] ?? ""
        );
  }

  String get creationDateFormatted =>
      DateTimeHelpers.ddmmyyyyHHnn(creationDate);
}
