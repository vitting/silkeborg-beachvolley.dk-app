import 'dart:async';

import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/confirm_dialog_action_enum.dart';

import 'confirm_dialog_functions.dart' as confirmFunctions;

class Dialogs {
  static Future<ConfirmDialogAction> confirmDelete(BuildContext context, String body) async {
    return confirmFunctions.confirmDialog(context, 
    body: [Text(body)],
    title: Text("Slet"),
    actionLeft: ConfirmDialogAction.cancel,
    actionRight: ConfirmDialogAction.delete,
    barrierDismissible: false
    );
  }

  static Future<ConfirmDialogAction> confirmHide(BuildContext context, String body) async {
    return confirmFunctions.confirmDialog(context, 
    body: [Text(body)],
    title: Text("Skjul"),
    actionLeft: ConfirmDialogAction.cancel,
    actionRight: ConfirmDialogAction.hide,
    barrierDismissible: false
    );
  }

  static Future<ConfirmDialogAction> confirmUnHide(BuildContext context, String body) async {
    return confirmFunctions.confirmDialog(context, 
    body: [Text(body)],
    title: Text("Vis"),
    actionLeft: ConfirmDialogAction.cancel,
    actionRight: ConfirmDialogAction.unhide,
    barrierDismissible: false
    );
  }

  static Future<ConfirmDialogAction> confirmReset(BuildContext context, String body) async {
    return confirmFunctions.confirmDialog(context, 
    body: [Text(body)],
    title: Text("Nulstil"),
    actionLeft: ConfirmDialogAction.cancel,
    actionRight: ConfirmDialogAction.reset,
    barrierDismissible: false
    );
  }

  static Future<ConfirmDialogAction> confirmError(BuildContext context, String body) async {
    return confirmFunctions.confirmDialog(context, 
    body: [Text(body)],
    title: Text("Fejl"),
    actionRight: ConfirmDialogAction.ok,
    barrierDismissible: true
    );
  }

  static Future<int> modalBottomSheet(BuildContext context, List<DialogsModalBottomSheetItem> items) async {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext contextModal) {
        List<Widget> widgets = items.map<Widget>((DialogsModalBottomSheetItem item) {
      return ListTile(
        leading: Icon(item.iconData),
        title: Text(item.title),
        onTap: () {
          Navigator.of(contextModal).pop(item.value);
        },
      );
    }).toList();
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widgets,
          ),
        );
      }
    );
  } 
}

class DialogsModalBottomSheetItem {
  final String title;
  final IconData iconData;
  final int value;

  DialogsModalBottomSheetItem(this.title, this.iconData, this.value);
}