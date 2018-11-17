import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import 'confirm_dialog_functions.dart' as confirmFunctions;

enum ConfirmDialogAction {
  delete,
  cancel,
  ok,
  yes,
  no,
  none,
  save,
  close,
  hide,
  unhide,
  reset,
  start
}

class Dialogs {
  static Future<ConfirmDialogAction> confirmDelete(
      BuildContext context, String body) async {
    return confirmFunctions.confirmDialog(context,
        body: [Text(body)],
        title: Text(FlutterI18n.translate(context, "delete")),
        actionLeft: ConfirmDialogAction.cancel,
        actionRight: ConfirmDialogAction.delete,
        barrierDismissible: false);
  }

  static Future<ConfirmDialogAction> confirmHide(
      BuildContext context, String body) async {
    return confirmFunctions.confirmDialog(context,
        body: [Text(body)],
        title: Text(FlutterI18n.translate(context, "hide")),
        actionLeft: ConfirmDialogAction.cancel,
        actionRight: ConfirmDialogAction.hide,
        barrierDismissible: false);
  }

  static Future<ConfirmDialogAction> confirmUnHide(
      BuildContext context, String body) async {
    return confirmFunctions.confirmDialog(context,
        body: [Text(body)],
        title: Text(FlutterI18n.translate(context, "show")),
        actionLeft: ConfirmDialogAction.cancel,
        actionRight: ConfirmDialogAction.unhide,
        barrierDismissible: false);
  }

  static Future<ConfirmDialogAction> confirmReset(
      BuildContext context, String body) async {
    return confirmFunctions.confirmDialog(context,
        body: [Text(body)],
        title: Text(FlutterI18n.translate(context, "reset")),
        actionLeft: ConfirmDialogAction.cancel,
        actionRight: ConfirmDialogAction.reset,
        barrierDismissible: false);
  }

  static Future<ConfirmDialogAction> confirmError(
      BuildContext context, String body) async {
    return confirmFunctions.confirmDialog(context,
        body: [Text(body)],
        title: Text(FlutterI18n.translate(context, "error")),
        actionRight: ConfirmDialogAction.ok,
        barrierDismissible: true);
  }

  static Future<ConfirmDialogAction> confirmSetWinner(
      BuildContext context, String body) async {
    return confirmFunctions.confirmDialog(context,
        body: [Text(body)],
        title: Text(FlutterI18n.translate(context, "setWinner")),
        actionLeft: ConfirmDialogAction.cancel,
        actionRight: ConfirmDialogAction.ok,
        barrierDismissible: false);
  }

  static Future<ConfirmDialogAction> confirmMatchWinner(
      BuildContext context, String body) async {
    return confirmFunctions.confirmDialog(context,
        body: [Text(body)],
        title: Text(FlutterI18n.translate(context, "matchWinner")),
        actionLeft: ConfirmDialogAction.cancel,
        actionRight: ConfirmDialogAction.ok,
        barrierDismissible: false);
  }

  static Future<ConfirmDialogAction> confirmMatchStart(
      BuildContext context, String body) async {
    return confirmFunctions.confirmDialog(context,
        body: [Text(body)],
        title: Text(FlutterI18n.translate(context, "startMatch")),
        actionLeft: ConfirmDialogAction.cancel,
        actionRight: ConfirmDialogAction.start,
        barrierDismissible: false);
  }

  static Future<ConfirmDialogAction> confirmYesNo(
      BuildContext context, String body) async {
    return confirmFunctions.confirmDialog(context,
        body: [Text(body)],
        title: Text(FlutterI18n.translate(context, "areYouSure")),
        actionLeft: ConfirmDialogAction.no,
        actionRight: ConfirmDialogAction.yes,
        barrierDismissible: false);
  }

  static Future<ConfirmDialogAction> confirmLogout(
      BuildContext context, String body) async {
    return confirmFunctions.confirmDialog(context,
        body: [Text(body)],
        title: Text(FlutterI18n.translate(context, "logout")),
        actionLeft: ConfirmDialogAction.no,
        actionRight: ConfirmDialogAction.yes,
        barrierDismissible: false);
  }

  static Future<int> modalBottomSheet(
      BuildContext context, List<DialogsModalBottomSheetItem> items) async {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext contextModal) {
          List<Widget> widgets =
              items.map<Widget>((DialogsModalBottomSheetItem item) {
            return ListTile(
              leading: Icon(item.iconData),
              title: Text(item.title),
              onTap: () {
                Navigator.of(contextModal).pop(item.value);
              },
            );
          }).toList();
          return Container(
            child: Scrollbar(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: widgets,
                  )
                ],
              ),
            ),
          );
        });
  }

  static Future<DialogsModalBottomSheetItem> modalBottomSheetExtended(
      BuildContext context, List<DialogsModalBottomSheetItem> items) async {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext contextModal) {
          List<Widget> widgets =
              items.map<Widget>((DialogsModalBottomSheetItem item) {
            return ListTile(
              leading: Icon(item.iconData),
              title: Text(item.title),
              onTap: () {
                Navigator.of(contextModal).pop(item);
              },
            );
          }).toList();
          return Container(
              child: ListView(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: widgets,
              ),
            ],
          ));
        });
  }
}

class DialogsModalBottomSheetItem {
  final String title;
  final IconData iconData;
  final int value;

  DialogsModalBottomSheetItem(this.title, this.iconData, this.value);
}
