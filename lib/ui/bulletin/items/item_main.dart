import 'dart:async';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/list_item_card_widget.dart';
import 'package:silkeborgbeachvolley/helpers/user_info_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/detailItem/detail_item_main.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/eventItem/event_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/playItem/play_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/newsItem/news_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/eventItem/event_item.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/playItem/play_item.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/newsItem/news_item.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import './item_functions.dart' as itemFunctions;

class BulletinItemMain extends StatelessWidget {
  final Map item;
  BulletinItemMain(this.item);

  @override
  Widget build(BuildContext context) {
    var bulletinItem;
    switch (item["type"]) {
      case "news":
        bulletinItem =
            _bulletinNewsItem(context, BulletinNewsItemData.fromMap(item));
        break;
      case "event":
        bulletinItem =
            _bulletinEventItem(context, BulletinEventItemData.fromMap(item));
        break;
      case "play":
        bulletinItem =
            _bulletinPlayItem(context, BulletinPlayItemData.fromMap(item));
        break;
    }

    return ListItemCard(
      child: bulletinItem,
    );
  }

  Widget _bulletinNewsItem(BuildContext context, BulletinNewsItemData bulletinItem) {
    if (bulletinItem.hiddenByUser.contains(Home.loggedInUser.uid)) return null;
    return BulletinNewsItem(
        bulletinItem: bulletinItem,
        onTap: () async {
          _navigateTobulletinDetailItem(context, bulletinItem);
        },
        onPressed: () => _bulletinItemOnPressed(context, bulletinItem));
  }

  Widget _bulletinEventItem(BuildContext context, BulletinEventItemData bulletinItem) {
    if (bulletinItem.hiddenByUser.contains(Home.loggedInUser.uid)) return null;
    return BulletinEventItem(
        bulletinItem: bulletinItem,
        onTap: () async {
          _navigateTobulletinDetailItem(context, bulletinItem);
        },
        onPressed: () => _bulletinItemOnPressed(context, bulletinItem));
  }

  Widget _bulletinPlayItem(BuildContext context, BulletinPlayItemData bulletinItem) {
    if (bulletinItem.hiddenByUser.contains(Home.loggedInUser.uid)) return null;
    return BulletinPlayItem(
        bulletinItem: bulletinItem,
        onTap: () async {
          _navigateTobulletinDetailItem(context, bulletinItem);
        },
        onPressed: () => _bulletinItemOnPressed(context, bulletinItem));
  }

  Future<void> _navigateTobulletinDetailItem(
      BuildContext context, BulletinItemData bulletinItem) async {
    await Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => BulletinDetailItem(bulletinItem)));
  }

  void _bulletinItemOnPressed(
      BuildContext context, BulletinItemData bulletinItem) {
    // UserInfoData userInfo = Home.userInfo;
    // if (userInfo?.id == bulletinItem.authorId)
      itemFunctions.bulletinItemPopupMenu(context, bulletinItem);
  }
}
