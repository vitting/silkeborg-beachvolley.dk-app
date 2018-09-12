import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/detailItem/detail_item_main.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/eventItem/event_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/playItem/play_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/newsItem/news_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/eventItem/event_item.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/playItem/play_item.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/newsItem/news_item.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';

class BulletinItemMain extends StatelessWidget {
  final Map item;
  BulletinItemMain(this.item);

  @override
  Widget build(BuildContext context) {
    var bulletinItem;
    switch (item["type"]) {
      case "news":
        bulletinItem = _bulletinNewsItem(context, BulletinNewsItemData.fromMap(item));
        break;
      case "event":
        bulletinItem = _bulletinEventItem(context, BulletinEventItemData.fromMap(item));
        break;
      case "play":
        bulletinItem = _bulletinPlayItem(context, BulletinPlayItemData.fromMap(item));
        break;
    }

    return bulletinItem;
  }

  Widget _bulletinNewsItem(
      BuildContext context, BulletinNewsItemData bulletinItem) {
    return Card(
      margin: EdgeInsets.all(5.0),
      child: BulletinNewsItem(
        bulletinItem: bulletinItem,
        onTap: () async {
          _navigateTobulletinDetailItem(context, bulletinItem);
        },
        onLongPress: () async => await _bulletinItemOnLongPress(context, bulletinItem.authorId)
        ),
    );
  }

  Widget _bulletinEventItem(
      BuildContext context, BulletinEventItemData bulletinItem) {
    return Card(
          margin: EdgeInsets.all(5.0),
          child: BulletinEventItem(
          bulletinItem: bulletinItem,
          onTap: () async {
            _navigateTobulletinDetailItem(context, bulletinItem);
          },
          onLongPress: () async => await _bulletinItemOnLongPress(context, bulletinItem.authorId)),
    );
  }

  Widget _bulletinPlayItem(
      BuildContext context, BulletinPlayItemData bulletinItem) {
    return Card(
          margin: EdgeInsets.all(5.0),
          child: BulletinPlayItem(
          bulletinItem: bulletinItem,
          onTap: () async {
            _navigateTobulletinDetailItem(context, bulletinItem);
          },
          onLongPress: () async => await _bulletinItemOnLongPress(context, bulletinItem.authorId)),
    );
  }

  Future<void> _navigateTobulletinDetailItem(BuildContext context, BulletinItemData bulletinItem) async {
    await Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => BulletinDetailItem(bulletinItem)));
  }

  Future<void> _bulletinItemOnLongPress(BuildContext context, String authorId) async {
    FirebaseUser userInfo = Home.loggedInUser;
    print("${userInfo.uid} / $authorId");
    if (userInfo.uid == authorId) _bulletinItemPopupMenu(context);
  }

  _bulletinItemPopupMenu(BuildContext context) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  onTap: () {
                    print("TAPPED");
                    Navigator.of(context).pop();
                  },
                  title: Text("Slet"),
                  leading: Icon(Icons.delete),
                ),
                Divider()
              ],
            ),
          );
        });
  }
}
