import 'dart:async';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/list_item_card_widget.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/detailItem/detail_item_main.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/eventItem/event_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/playItem/play_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/newsItem/news_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/eventItem/event_item.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/playItem/play_item.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/newsItem/news_item.dart';
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
    if (bulletinItem == null) return Container();
    return ListItemCard(
      child: bulletinItem,
    );
  }

  Widget _bulletinNewsItem(
      BuildContext context, BulletinNewsItemData bulletinItem) {
    return BulletinNewsItem(
        bulletinItem: bulletinItem,
        onTap: () async {
          _navigateTobulletinDetailItem(context, bulletinItem);
        },
        onPressed: () => _bulletinItemOnPressed(context, bulletinItem));
  }

  Widget _bulletinEventItem(
      BuildContext context, BulletinEventItemData bulletinItem) {
    return BulletinEventItem(
        bulletinItem: bulletinItem,
        onTap: () async {
          _navigateTobulletinDetailItem(context, bulletinItem);
        },
        onPressed: () => _bulletinItemOnPressed(context, bulletinItem));
  }

  Widget _bulletinPlayItem(
      BuildContext context, BulletinPlayItemData bulletinItem) {
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
    itemFunctions.bulletinItemPopupMenu(context, bulletinItem);
  }
}
