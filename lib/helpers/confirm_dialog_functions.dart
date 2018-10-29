import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/confirm_dialog_action_enum.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_theme.dart';

Future<ConfirmDialogAction> confirmDialog(
  BuildContext context, {
  @required Widget title,
  @required List<Widget> body,
  ConfirmDialogAction actionLeft = ConfirmDialogAction.none,
  ConfirmDialogAction actionRight = ConfirmDialogAction.ok,
  bool barrierDismissible = false,
}) async {
  List<Widget> actions = [];

  if (actionLeft != ConfirmDialogAction.none) {
    actions.add(FlatButton(
        textColor: SilkeborgBeachvolleyTheme.buttonTextColor,
        child: _getButtonText(context, actionLeft),
        onPressed: () {
          Navigator.of(context).pop(actionLeft);
        }));
  }

  if (actionRight != ConfirmDialogAction.none) {
    actions.add(FlatButton(
        textColor: SilkeborgBeachvolleyTheme.buttonTextColor,
        child: _getButtonText(context, actionRight),
        onPressed: () {
          Navigator.of(context).pop(actionRight);
        }));
  }
  return showDialog<ConfirmDialogAction>(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title,
          content: SingleChildScrollView(
              child: ListBody(
            children: body,
          )),
          actions: actions,
        );
      });
}

Text _getButtonText(BuildContext context, ConfirmDialogAction action) {
  String value;

  switch (action) {
    case ConfirmDialogAction.cancel:
      value = FlutterI18n.translate(context, "cancel");
      break;
    case ConfirmDialogAction.delete:
      value = FlutterI18n.translate(context, "delete");
      break;
    case ConfirmDialogAction.no:
      value = FlutterI18n.translate(context, "no");
      break;
    case ConfirmDialogAction.yes:
      value = FlutterI18n.translate(context, "yes");
      break;
    case ConfirmDialogAction.ok:
      value = FlutterI18n.translate(context, "ok");
      break;
    case ConfirmDialogAction.save:
      value = FlutterI18n.translate(context, "save");
      break;
    case ConfirmDialogAction.close:
      value = FlutterI18n.translate(context, "close");
      break;
    case ConfirmDialogAction.hide:
      value = FlutterI18n.translate(context, "hide");
      break;
    case ConfirmDialogAction.unhide:
      value = FlutterI18n.translate(context, "show");
      break;
    case ConfirmDialogAction.reset:
      value = FlutterI18n.translate(context, "reset");
      break;
    case ConfirmDialogAction.start:
      value = FlutterI18n.translate(context, "start");
      break;
    default:
      value = "";
  }

  return Text(value);
}
