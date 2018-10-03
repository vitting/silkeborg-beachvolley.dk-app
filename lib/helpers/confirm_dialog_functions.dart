import 'dart:async';

import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/confirm_dialog_action_enum.dart';

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
        child: _getButtonText(actionLeft),
        onPressed: () {
          Navigator.of(context).pop(actionLeft);
        }));
  }

  if (actionRight != ConfirmDialogAction.none) {
    actions.add(FlatButton(
        child: _getButtonText(actionRight),
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

Text _getButtonText(ConfirmDialogAction action) {
  String value;

  switch (action) {
    case ConfirmDialogAction.cancel:
      value = "Anuller";
      break;
    case ConfirmDialogAction.delete:
      value = "Slet";
      break;
    case ConfirmDialogAction.no:
      value = "Nej";
      break;
    case ConfirmDialogAction.yes:
      value = "Ja";
      break;
    case ConfirmDialogAction.ok:
      value = "Ok";
      break;
    case ConfirmDialogAction.save:
      value = "Gem";
      break;
    case ConfirmDialogAction.close:
      value = "Luk";
      break;
    default:
      value = "";
  }

  return Text(value);
}
