import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/uuid_helpers.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_firestore.dart';

class BulletinCommentItemData {
  String id;
  String bulletinId;
  String body;
  Timestamp creationDate;
  String authorId;
  String authorName;
  String authorPhotoUrl;

  BulletinCommentItemData(
      {this.id,
      this.bulletinId = "",
      this.body = "",
      this.creationDate,
      this.authorId,
      this.authorName,
      this.authorPhotoUrl});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "bulletinId": bulletinId,
      "body": body,
      "creationDate": creationDate ?? Timestamp.now(),
      "author": {
        "id": authorId,
        "name": authorName,
        "photoUrl": authorPhotoUrl
      },
    };
  }

  Future<void> save(FirebaseUser user) {
    id = id ?? UuidHelpers.generateUuid();
    authorId = authorId ?? user.uid;
    authorName = authorName ?? user.displayName;
    authorPhotoUrl = authorPhotoUrl ?? user.photoUrl;

    return BulletinFirestore.saveCommentItem(this);
  }

  static fromMap(Map<String, dynamic> item) {
    return new BulletinCommentItemData(
        id: item["id"] ?? "",
        bulletinId: item["bulletinId"] ?? "",
        body: item["body"] ?? "",
        creationDate: item["creationDate"],
        authorId: item["author"]["id"] ?? "",
        authorName: item["author"]["name"] ?? "",
        authorPhotoUrl: item["author"]["photoUrl"] ?? "");
  }

  String get creationDateFormatted =>
      DateTimeHelpers.ddmmyyyyHHnn(creationDate.toDate());

  Future<void> delete() {
    return BulletinFirestore.deleteComment(id);
  }
}
