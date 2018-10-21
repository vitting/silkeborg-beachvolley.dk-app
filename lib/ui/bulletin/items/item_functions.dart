import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/confirm_dialog_action_enum.dart';
import 'package:silkeborgbeachvolley/helpers/dialogs_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/confirm_dialog_options_data.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_item_data.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/editItem/bulletin_edit_item_main.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/eventItem/event_item_data.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/newsItem/news_item_data.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/playItem/play_item_data.dart';
import '../../../helpers/confirm_dialog_functions.dart'
    as confirmDialogFunctions;

void bulletinItemPopupMenu(
    BuildContext context, BulletinItemData bulletinItem) async {
  List<DialogsModalBottomSheetItem> items = [
    DialogsModalBottomSheetItem(FlutterI18n.translate(context, "bulletin.itemFunctions.string1"), Icons.edit, 0),
    DialogsModalBottomSheetItem(FlutterI18n.translate(context, "bulletin.itemFunctions.string2"), Icons.delete, 1)
  ];

  int result = await Dialogs.modalBottomSheet(context, items);

  if (result != null) {
    switch (result) {
      case 0:

        ///Edit
        Navigator.of(context).push(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (BuildContext context) => EditBulletinItem(bulletinItem)));
        break;
      case 1:

        ///Delete
        bulletinConfirmDialog(context, bulletinItem);
        break;
    }
  }
}

void bulletinConfirmDialog(
    BuildContext context, BulletinItemData bulletinItem) async {
  ConfirmDialogOptionsData dialogOptions =
      getConfimDialogOptions(context, bulletinItem.type);
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

ConfirmDialogOptionsData getConfimDialogOptions(BuildContext context, BulletinType type) {
  ConfirmDialogOptionsData dialogOptions = new ConfirmDialogOptionsData();
  switch (type) {
    case BulletinType.news:
      dialogOptions.title = Text(FlutterI18n.translate(context, "bulletin.itemFunctions.string3"));
      dialogOptions.body = [
        Text(FlutterI18n.translate(context, "bulletin.itemFunctions.string4")),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(
              FlutterI18n.translate(context, "bulletin.itemFunctions.string5")),
        )
      ];

      break;
    case BulletinType.event:
      dialogOptions.title = Text(FlutterI18n.translate(context, "bulletin.itemFunctions.string6"));
      dialogOptions.body = [
        Text(FlutterI18n.translate(context, "bulletin.itemFunctions.string7")),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(
              FlutterI18n.translate(context, "bulletin.itemFunctions.string8")),
        )
      ];

      break;
    case BulletinType.play:
      dialogOptions.title = Text(FlutterI18n.translate(context, "bulletin.itemFunctions.string9"));
      dialogOptions.body = [
        Text(FlutterI18n.translate(context, "bulletin.itemFunctions.string10")),
        Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
                FlutterI18n.translate(context, "bulletin.itemFunctions.string11")))
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
