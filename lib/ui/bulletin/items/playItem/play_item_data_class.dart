import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_firestore.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/playItem/player_committed_class.dart';

class BulletinPlayItemData extends BulletinItemData {
  int numberOfPlayersCommitted;
  
  BulletinPlayItemData(
      {String id = "",
      String type = BulletinType.none,
      String body = "",
      DateTime creationDate,
      String authorId = "",
      String authorName = "",
      String authorPhotoUrl = "",
      int numberOfcomments = 0, this.numberOfPlayersCommitted = 0})
      : super(
            id: id,
            type: type,
            body: body,
            creationDate: creationDate,
            authorId: authorId,
            authorName: authorName,
            authorPhotoUrl: authorPhotoUrl,
            numberOfcomments: numberOfcomments);

  Stream<QuerySnapshot> getPlayersCommittedAsStream() {
    return BulletinFirestore.getPlayersCommittedAsStream(id); 
  }

  Future<bool> isCommitted() async {
    return await BulletinFirestore.checkIfPlayerIsCommited(id, authorId);
  }

  void setPlayerAsCommitted() async {
    PlayerCommitted playerCommitted = PlayerCommitted(
      bulletinId: id,
      name: authorName,
      photoUrl: authorPhotoUrl,
      userId: authorId
    );

    await BulletinFirestore.savePlayerCommitted(playerCommitted);
  }

  void setPlayerAsUnCommitted() async {
    await BulletinFirestore.deletePlayerCommitted(id, authorId);
  }

  static BulletinPlayItemData fromMap(Map<String, dynamic> item) {
    return new BulletinPlayItemData(
        id: item["id"] == null ? "" : item["id"],
        type: item["type"] == null ? "" : item["type"],
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
