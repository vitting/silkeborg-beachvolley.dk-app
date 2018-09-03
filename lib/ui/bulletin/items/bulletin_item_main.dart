import 'dart:async';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/bulletin_item_class.dart';
import 'package:silkeborgbeachvolley/helpers/local_user_info_class.dart';
import 'package:silkeborgbeachvolley/helpers/userauth.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/bulletin_detail_item_main.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/bulletin_event_item.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/bulletin_game_item.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/bulletin_news_item.dart';

class BulletinItemMain extends StatelessWidget {
  final Map item;
  BulletinItemMain(this.item);

  @override
  Widget build(BuildContext context) {
    BulletinItem _bulletinItem = BulletinItem.fromMap(item);
    return _bulletinItemBody(context, _bulletinItem);
  }

  Widget _bulletinItemBody(BuildContext context, BulletinItem bulletinItem) {
    return BulletinNewsItem(
      bulletinItem: bulletinItem,
      onTap: () async {
        _navigateTobulletinDetailItem(context, bulletinItem);
      },
      onLongPress: () async {
        LocalUserInfo localUserInfo = await UserAuth.getLoclUserInfo();
        print("${localUserInfo.id} / ${bulletinItem.authorId}");
        if (localUserInfo.id == bulletinItem.authorId)
          _bulletinItemPopupMenu(context);
      }
    );
  }

  Widget _bulletinItemBody2(BuildContext context, BulletinItem bulletinItem) {
    return BulletinEventItem(
      bulletinItem: bulletinItem,
      onTap: () async {
        _navigateTobulletinDetailItem(context, bulletinItem);
      },
      onLongPress: () async {
        LocalUserInfo localUserInfo = await UserAuth.getLoclUserInfo();
        print("${localUserInfo.id} / ${bulletinItem.authorId}");
        if (localUserInfo.id == bulletinItem.authorId)
          _bulletinItemPopupMenu(context);
      },
    );
  }

  Widget _bulletinItemBody3(BuildContext context, BulletinItem bulletinItem) {
    return BulletinGameItem(
      bulletinItem: bulletinItem,
      onTap: () async {
        _navigateTobulletinDetailItem(context, bulletinItem);
      },
      onLongPress: () async {
        LocalUserInfo localUserInfo = await UserAuth.getLoclUserInfo();
        print("${localUserInfo.id} / ${bulletinItem.authorId}");
        if (localUserInfo.id == bulletinItem.authorId)
          _bulletinItemPopupMenu(context);
      }
    );
  }

  Widget _bulletinDateTimeNumberOfComments(
      BuildContext context, BulletinItem bulletinItem) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        children: <Widget>[
          Icon(Icons.access_time, size: 12.0),
          Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 20.0),
              child: Text(
                bulletinItem.creationDateFormatted,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 12.0),
              )),
          Icon(
            Icons.chat_bubble_outline,
            size: 12.0,
          ),
          Padding(
              padding: const EdgeInsetsDirectional.only(start: 5.0),
              child: Text(
                bulletinItem.numberOfcomments.toString(),
                style: TextStyle(fontSize: 12.0),
              ))
        ],
      ),
    );
  }

  Future<bool> _navigateTobulletinDetailItem(
      BuildContext context, BulletinItem bulletinItem) async {
    return await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => BulletinDetailItem(bulletinItem)));
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
