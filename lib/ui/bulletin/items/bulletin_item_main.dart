import 'dart:async';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/local_user_info_class.dart';
import 'package:silkeborgbeachvolley/helpers/userauth.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/bulletin_detail_item_main.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_event_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_play_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_news_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/bulletin_event_item.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/bulletin_play_item.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/bulletin_news_item.dart';

class BulletinItemMain extends StatelessWidget {
  final Map item;
  final String type;
  BulletinItemMain(this.item, this.type);

  @override
  Widget build(BuildContext context) {
    print(type);
    switch (type) {
      case "news":
        return _bulletinNewsItem(context, BulletinNewsItemData.fromMap(item));
      case "event":
        return _bulletinEventItem(context, BulletinEventItemData.fromMap(item));
      case "play":
        return _bulletinPlayItem(context, BulletinPlayItemData.fromMap(item));
    }
  }

  Widget _bulletinNewsItem(
      BuildContext context, BulletinNewsItemData bulletinItem) {
    return BulletinNewsItem(
        bulletinItem: bulletinItem,
        onTap: () async {
          _navigateTobulletinDetailItem(context, bulletinItem);
        },
        onLongPress: () async => await _bulletinItemOnLongPress(context, bulletinItem.authorId)
        );
  }

  Widget _bulletinEventItem(
      BuildContext context, BulletinEventItemData bulletinItem) {
    return BulletinEventItem(
        bulletinItem: bulletinItem,
        showDivider: true,
        onTap: () async {
          _navigateTobulletinDetailItem(context, bulletinItem);
        },
        onLongPress: () async => await _bulletinItemOnLongPress(context, bulletinItem.authorId));
  }

  Widget _bulletinPlayItem(
      BuildContext context, BulletinPlayItemData bulletinItem) {
    return BulletinPlayItem(
        bulletinItem: bulletinItem,
        onTap: () async {
          _navigateTobulletinDetailItem(context, bulletinItem);
        },
        onLongPress: () async => await _bulletinItemOnLongPress(context, bulletinItem.authorId));
  }

  Future<void> _navigateTobulletinDetailItem(
      BuildContext context, BulletinItemData bulletinItem) async {
    await Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => BulletinDetailItem(bulletinItem)));
  }

  Future<void> _bulletinItemOnLongPress(BuildContext context, String authorId) async {
    LocalUserInfo localUserInfo = await UserAuth.getLoclUserInfo();
    print("${localUserInfo.id} / $authorId");
    if (localUserInfo.id == authorId) _bulletinItemPopupMenu(context);
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
