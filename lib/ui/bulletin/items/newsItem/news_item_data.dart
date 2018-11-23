import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:silkeborgbeachvolley/helpers/image_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/system_helpers.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_firestore.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_image_data.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_item_data.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';

class BulletinNewsItemData extends BulletinItemData {
  List<BulletinImageData> images;
  BulletinNewsItemData(
      {String id,
      BulletinType type = BulletinType.none,
      String body = "",
      Timestamp creationDate,
      String authorId,
      String authorName,
      String authorPhotoUrl,
      int numberOfcomments = 0,
      this.images})
      : super(
          id: id,
          type: type,
          body: body,
          creationDate: creationDate,
          authorId: authorId,
          authorName: authorName,
          authorPhotoUrl: authorPhotoUrl,
          numberOfcomments: numberOfcomments,
        );

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();
    map.addAll({
      "images": images.map((BulletinImageData data) {
            return data.toMap();
          }).toList() ??
          []
    });
    return map;
  }

  ///Deletes all images, comments and the news item.
  @override
  Future<bool> delete() async {
    try {
      await ImageHelpers.deleteBulletinImages(images);
      return super.delete();
    } catch (e) {
      print("NewsItemData - delete() : $e");
      return false;
    }
  }

  Future<void> save(FirebaseUser user) async {
    id = id ?? SystemHelpers.generateUuid();
    creationDate = creationDate ?? Timestamp.now();
    authorId = user.uid;
    authorName = user.displayName;
    authorPhotoUrl = user.photoUrl;
    images = images ?? [];
    return BulletinFirestore.saveBulletinItem(this);
  }

  factory BulletinNewsItemData.fromMap(Map<dynamic, dynamic> item) {
    return new BulletinNewsItemData(
      id: item["id"] ?? "",
      type: BulletinTypeHelper.getBulletinTypeStringAsType(item["type"]),
      authorId: item["author"]["id"] ?? "",
      authorName: item["author"]["name"] ?? "",
      authorPhotoUrl: item["author"]["photoUrl"] ?? "",
      body: item["body"] ?? "",
      creationDate: item["creationDate"] ?? "",
      numberOfcomments: item["numberOfcomments"] ?? 0,
      images: item["images"] == null
          ? []
          : (item["images"] as List<dynamic>)
              .map<BulletinImageData>((dynamic data) {
              return BulletinImageData.fromMap(data);
            }).toList(),
    );
  }
}
