import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/confirm_dialog_action_enum.dart';
import 'package:silkeborgbeachvolley/helpers/dialogs_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/confirm_dialog_options_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/editItem/bulletin_edit_item_main.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/eventItem/event_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/newsItem/news_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/playItem/play_item_data_class.dart';
import '../../../helpers/confirm_dialog_functions.dart'
    as confirmDialogFunctions;

void bulletinItemPopupMenu(
    BuildContext context, BulletinItemData bulletinItem) async {
  List<DialogsModalBottomSheetItem> items = [
    DialogsModalBottomSheetItem("Rediger", Icons.edit, 0),
    DialogsModalBottomSheetItem("Slet", Icons.delete, 1)
  ];
  

  int result = await Dialogs.modalBottomSheet(context, items);

  if (result != null) {
    switch (result) {
      case 0: ///Edit
        Navigator.of(context).push(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (BuildContext context) => EditBulletinItem(bulletinItem)));
        break;
      case 1: ///Delete
        bulletinConfirmDialog(context, bulletinItem);
        break;
    }
  }
}

void bulletinConfirmDialog(
    BuildContext context, BulletinItemData bulletinItem) async {
  ConfirmDialogOptions dialogOptions =
      getConfimDialogOptions(bulletinItem.type);
  ConfirmDialogAction result = await confirmDialogFunctions.confirmDialog(
      context,
      body: dialogOptions.body,
      title: dialogOptions.title,
      actionLeft: ConfirmDialogAction.cancel,
      actionRight: ConfirmDialogAction.delete);

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
