import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silkeborgbeachvolley/helpers/base_data_class.dart';
import 'package:silkeborgbeachvolley/helpers/uuid_helpers.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_firestore.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/playItem/player_committed_data_class.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';

class BulletinPlayItemData extends BulletinItemData implements BaseData {
  int numberOfPlayersCommitted;

  BulletinPlayItemData(
      {String id,
      BulletinType type = BulletinType.none,
      String body = "",
      dynamic creationDate,
      String authorId,
      String authorName,
      String authorPhotoUrl,
      int numberOfcomments = 0,
      List<dynamic> hiddenByUser,
      this.numberOfPlayersCommitted = 0})
      : super(
            id: id,
            type: type,
            body: body,
            creationDate: creationDate,
            authorId: authorId,
            authorName: authorName,
            authorPhotoUrl: authorPhotoUrl,
            hiddenByUser: hiddenByUser,
            numberOfcomments: numberOfcomments);

  Future<int> getUpdatedNumberOfPlayerCommittedCount() async {
    DocumentSnapshot snapshot = await BulletinFirestore.getBulletinItem(id);
    if (snapshot.exists) {
      numberOfPlayersCommitted = snapshot.data["numberOfPlayersCommitted"];
    }

    return numberOfPlayersCommitted;
  }

  Future<List<PlayerCommittedData>> getPlayersCommitted() async {
    QuerySnapshot data = await BulletinFirestore.getPlayersCommitted(id);

    return data.documents.map<PlayerCommittedData>((DocumentSnapshot doc) {
      return PlayerCommittedData.fromMap(doc.data);
    }).toList();
  }

  Future<bool> isCommitted() async {
    return await BulletinFirestore.checkIfPlayerIsCommited(
        id, Home.loggedInUser.uid);
  }

  Future<void> setPlayerAsCommitted() async {
    PlayerCommittedData playerCommitted = PlayerCommittedData(
        bulletinId: id,
        name: Home.loggedInUser.displayName,
        photoUrl: Home.loggedInUser.photoUrl,
        userId: Home.loggedInUser.uid);

    await BulletinFirestore.savePlayerCommitted(playerCommitted);
  }

  Future<void> setPlayerAsUnCommitted() async {
    await BulletinFirestore.deletePlayerCommitted(id, authorId);
  }

  Future<void> deletePlayersCommitted() async {
    await BulletinFirestore.deletePlayersCommittedByBulletinId(id);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();
    map.addAll({"numberOfPlayersCommitted": numberOfPlayersCommitted});
    return map;
  }

  ///Deletes all images, comments and the play item.
  Future<bool> delete() async {
    try {
      await deletePlayersCommitted();

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
        numberOfPlayersCommitted: item["numberOfPlayersCommitted"] ?? 0,
        hiddenByUser: item["hiddenByUser"] ?? []
    );
  }
}
