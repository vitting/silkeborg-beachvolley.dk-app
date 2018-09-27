 import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/confirm_dialog_options_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/editItem/bulletin_edit_item_main.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/eventItem/event_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/newsItem/news_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/playItem/play_item_data_class.dart';

void bulletinItemPopupMenu(
      BuildContext context, BulletinItemData bulletinItem) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext contextModal) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  onTap: () {
                    bulletinItem.hide();
                    Navigator.of(contextModal).pop();
                    Scaffold.of(context).showSnackBar(SnackBar(
                      duration: Duration(seconds: 10),
                      content: Text("Opslaget er skjult"),
                      action: SnackBarAction(
                        label: "Fortryd",
                        onPressed: () {
                          bulletinItem.unhide();
                        },
                      ),
                    ));
                    
                  },
                  title: Text("Skjul"),
                  leading: Icon(Icons.visibility_off),
                ),
                Divider(),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (BuildContext context) => EditBulletinItem(bulletinItem)
                    ));
                  },
                  title: Text("Rediger"),
                  leading: Icon(Icons.edit),
                ),
                Divider(),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    bulletinConfirmDialog(context, bulletinItem);
                  },
                  title: Text("Slet"),
                  leading: Icon(Icons.delete),
                )
              ],
            ),
          );
        });
  }

  void bulletinConfirmDialog(
      BuildContext context, BulletinItemData bulletinItem) async {
    ConfirmDialogOptions dialogOptions =
        getConfimDialogOptions(bulletinItem.type);
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

    if (result == ConfirmDialogAction.delete) {
      deleteBulletinItem(bulletinItem);
    }
  }

  ConfirmDialogOptions getConfimDialogOptions(BulletinType type) {
    ConfirmDialogOptions dialogOptions = new ConfirmDialogOptions();
    switch (type) {
      case BulletinType.news:
        dialogOptions.title = Text("Slet nyhed");
        dialogOptions.body = [
          Text("Er du sikker på du vil slette din nyhed?"),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
                "Du skal være opmærksom på at alle billeder og kommentarer for nyheden også vil bliver slettet"),
          )
        ];

        break;
      case BulletinType.event:
        dialogOptions.title = Text("Slet begivenhed");
        dialogOptions.body = [
          Text("Er du sikker på du vil slette din begivenhed?"),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
                "Du skal være opmærksom på at alle kommentarer for begivenheden også vil bliver slettet"),
          )
        ];

        break;
      case BulletinType.play:
        dialogOptions.title = Text("Slet spil");
        dialogOptions.body = [
          Text("Er du sikker på du vil slette dit opslag om spil?"),
          Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                  "Du skal være opmærksom på at alle kommentarer for opsalget også vil bliver slettet"))
        ];

        break;
      case BulletinType.none:
        break;
    }

    return dialogOptions;
  }

  void deleteBulletinItem(BulletinItemData bulletinItem) {
    if (bulletinItem.type == BulletinType.news) {
      (bulletinItem as BulletinNewsItemData).delete();
    }

    if (bulletinItem.type == BulletinType.event) {
      (bulletinItem as BulletinEventItemData).delete();
    }

    if (bulletinItem.type == BulletinType.play) {
      (bulletinItem as BulletinPlayItemData).delete();
    }
  }