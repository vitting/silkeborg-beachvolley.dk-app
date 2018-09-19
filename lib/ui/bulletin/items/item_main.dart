import 'dart:async';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/user_info_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';
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

    return Card(
      margin: EdgeInsets.all(5.0),
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
        onLongPress: () => _bulletinItemOnLongPress(
            context, bulletinItem));
  }

  Widget _bulletinEventItem(
      BuildContext context, BulletinEventItemData bulletinItem) {
    return BulletinEventItem(
        bulletinItem: bulletinItem,
        onTap: () async {
          _navigateTobulletinDetailItem(context, bulletinItem);
        },
        onLongPress: () => _bulletinItemOnLongPress(
            context, bulletinItem));
  }

  Widget _bulletinPlayItem(
      BuildContext context, BulletinPlayItemData bulletinItem) {
    return BulletinPlayItem(
        bulletinItem: bulletinItem,
        onTap: () async {
          _navigateTobulletinDetailItem(context, bulletinItem);
        },
        onLongPress: () => _bulletinItemOnLongPress(
            context, bulletinItem));
  }

  Future<void> _navigateTobulletinDetailItem(
      BuildContext context, BulletinItemData bulletinItem) async {
    await Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => BulletinDetailItem(bulletinItem)));
  }

  void _bulletinItemOnLongPress(
      BuildContext context, BulletinItemData bulletinItem) {
    UserInfoData userInfo = Home.userInfo;
    if (userInfo?.id == bulletinItem.authorId) _bulletinItemPopupMenu(context, bulletinItem);
  }

  void _bulletinItemPopupMenu(BuildContext context, BulletinItemData bulletinItem) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    _bulletinConfirmDialog(context, bulletinItem);
                  },
                  title: Text("Rediger"),
                  leading: Icon(Icons.edit),
                ),
                Divider(),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  title: Text("Slet"),
                  leading: Icon(Icons.delete),
                )
              ],
            ),
          );
        });
  }

  void _bulletinConfirmDialog(BuildContext context, BulletinItemData bulletinItem) async {
    ConfirmDialogOptions dialogOptions = _getConfimDialogOptions(bulletinItem.type);
    ConfirmDialogAction result = await showDialog<ConfirmDialogAction>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: dialogOptions.title,
            content: SingleChildScrollView(
                child: ListBody(
              children: dialogOptions.body,
            )),
            actions: <Widget>[
              FlatButton(
                  child: Text("Anuller"),
                  onPressed: () {
                    Navigator.of(context).pop(ConfirmDialogAction.cancel);
                  }),
              FlatButton(
                  child: Text("Slet"),
                  onPressed: () {
                    Navigator.of(context).pop(ConfirmDialogAction.delete);
                  })
            ],
          );
        });

    //CHRISTIAN: Delete function... What to do :)
    print(result);
  }

  ConfirmDialogOptions _getConfimDialogOptions(BulletinType type) {
    ConfirmDialogOptions dialogOptions = new ConfirmDialogOptions();
    switch (type) {
      case BulletinType.news:
        dialogOptions.title = Text("Slet nyhed");
        dialogOptions.body.add(Text("Er du sikker på du vil slette din nyhed?"));
        dialogOptions.body.add(Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(
              "Du skal være opmærksom på at alle billeder og kommentarer for nyheden også vil bliver slettet"),
        ));
        break;
      case BulletinType.event:
        dialogOptions.title = Text("Slet begivenhed");
        dialogOptions.body.add(Text("Er du sikker på du vil slette din begivenhed?"));
        dialogOptions.body.add(Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(
              "Du skal være opmærksom på at alle kommentarer for begivenheden også vil bliver slettet"),
        ));
        break;
      case BulletinType.play:
        dialogOptions.title = Text("Slet spil");
        dialogOptions.body.add(Text("Er du sikker på du vil slette dit opslag om spil?"));
        dialogOptions.body.add(Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(
              "Du skal være opmærksom på at alle kommentarer for opsalget også vil bliver slettet"),
        ));
        break;
      case BulletinType.none:
        break;
    }

    return dialogOptions;
  }
}

enum ConfirmDialogAction {
  delete,
  cancel
}

class ConfirmDialogOptions {
  BulletinType type;
  Text title;
  final List<Widget> body;

  ConfirmDialogOptions({this.type, this.title, this.body});
}