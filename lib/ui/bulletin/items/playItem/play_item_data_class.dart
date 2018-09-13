import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_firestore.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/playItem/player_committed_class.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';

class BulletinPlayItemData extends BulletinItemData {
  int numberOfPlayersCommitted;
  
  BulletinPlayItemData(
      {String id = "",
      BulletinType type = BulletinType.none,
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

  Future<int> getUpdatedNumberOfPlayerCommittedCount() async {
    DocumentSnapshot snapshot = await BulletinFirestore.getBulletinItem(id);
    if (snapshot.exists) {
      numberOfPlayersCommitted = snapshot.data["numberOfPlayersCommitted"];
    }

    return numberOfPlayersCommitted;
  }

  Future<List<PlayerCommitted>> getPlayersCommitted() async {
    QuerySnapshot data = await BulletinFirestore.getPlayersCommitted(id);
    
    return data.documents.map<PlayerCommitted>((DocumentSnapshot doc) {
        return PlayerCommitted.fromMap(doc.data);
      }).toList();
  }

  Future<bool> isCommitted() async {
    return await BulletinFirestore.checkIfPlayerIsCommited(id, Home.loggedInUser.uid);
  }

  void setPlayerAsCommitted() async {
    PlayerCommitted playerCommitted = PlayerCommitted(
      bulletinId: id,
      name: Home.loggedInUser.displayName,
      photoUrl: Home.loggedInUser.photoUrl,
      userId: Home.loggedInUser.uid
    );

    await BulletinFirestore.savePlayerCommitted(playerCommitted);
  }

  void setPlayerAsUnCommitted() async {
    await BulletinFirestore.deletePlayerCommitted(id, authorId);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();
    map.addAll({"numberOfPlayersCommitted": numberOfPlayersCommitted});
    return map;
  }

  static BulletinPlayItemData fromMap(Map<String, dynamic> item) {
    print(item["numberOfPlayersCommitted"]);
    return new BulletinPlayItemData(
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
            item["numberOfcomments"] == null ? 0 : item["numberOfcomments"],
        numberOfPlayersCommitted: item["numberOfPlayersCommitted"] == null ? 0 : item["numberOfPlayersCommitted"]
            );
  }
}
