import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silkeborgbeachvolley/helpers/base_data_class.dart';
import 'package:silkeborgbeachvolley/helpers/uuid_helpers.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_firestore.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';

class BulletinPlayItemData extends BulletinItemData implements BaseData {
  BulletinPlayItemData(
      {String id,
      BulletinType type = BulletinType.none,
      String body = "",
      dynamic creationDate,
      String authorId,
      String authorName,
      String authorPhotoUrl,
      int numberOfcomments = 0,
      List<String> hiddenByUser,
      int numberOfCommits = 0})
      : super(
            id: id,
            type: type,
            body: body,
            creationDate: creationDate,
            authorId: authorId,
            authorName: authorName,
            authorPhotoUrl: authorPhotoUrl,
            hiddenByUser: hiddenByUser,
            numberOfcomments: numberOfcomments,
            numberOfCommits: numberOfCommits);

  ///Deletes all images, comments and the play item.
  Future<bool> delete() async {
    try {
      await deleteCommitted();

      return super.delete();
    } catch (e) {
      print("PlayItemData - delete() : $e");
      return false;
    }
  }

  Future<void> save() async {
    id = id ?? UuidHelpers.generateUuid();
    creationDate = creationDate ?? FieldValue.serverTimestamp();
    authorId = Home.loggedInUser.uid;
    authorName = Home.loggedInUser.displayName;
    authorPhotoUrl = Home.loggedInUser.photoUrl;
    return BulletinFirestore.saveBulletinItem(this);
  }

  factory BulletinPlayItemData.fromMap(Map<String, dynamic> item) {
    return new BulletinPlayItemData(
        id: item["id"] ?? "",
        type: BulletinTypeHelper.getBulletinTypeStringAsType(item["type"]),
        authorId: item["author"]["id"] ?? "",
        authorName: item["author"]["name"] ?? "",
        authorPhotoUrl: item["author"]["photoUrl"] ?? "",
        body: item["body"] ?? "",
        creationDate: item["creationDate"] ?? DateTime.now(),
        numberOfcomments: item["numberOfcomments"] ?? 0,
        numberOfCommits: item["numberOfCommits"] ?? 0,
        hiddenByUser: item["hiddenByUser"] == null ? [] : (item["hiddenByUser"] as List<dynamic>).map<String>((dynamic id) {
          return id;
        }).toList());
  }
}
