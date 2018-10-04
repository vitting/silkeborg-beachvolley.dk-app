import 'dart:async';

import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/confirm_dialog_action_enum.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/helpers/enrollment_payment_data.dart';
import "../../../helpers/confirm_dialog_functions.dart" as confirmActions;

Future<String> editComment(
    BuildContext context, String text) async {
  String comment;
  TextEditingController _commentController =
      TextEditingController(text: text);
  ConfirmDialogAction result = await confirmActions.confirmDialog(context,
      title: Text("Kommentar"),
      barrierDismissible: false,
      actionRight: ConfirmDialogAction.close,
      body: <Widget>[
        Container(
          child: TextField(
            controller: _commentController,
            maxLength: 500,
            maxLines: 4,
            decoration: InputDecoration(
                labelText: "Kommentar",
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    Navigator.of(context).pop(ConfirmDialogAction.save);
                  },
                )),
          ),
        )
      ]);

  if (result != null && result == ConfirmDialogAction.save) {
    comment = _commentController.text;
  }

  return comment;
}

Future<bool> deletePayment(
    BuildContext context, EnrollmentPaymentData payment) async {
  ConfirmDialogAction result = await confirmActions.confirmDialog(context,
      title: Text("slet betaling"),
      barrierDismissible: false,
      actionLeft: ConfirmDialogAction.cancel,
      actionRight: ConfirmDialogAction.delete,
      body: <Widget>[Text("Vil du slette betaling for ${payment.year}")]);

  if (result != null && result == ConfirmDialogAction.delete) {
    return true;
  }

  return false;
}

Future<int> chooseYear(BuildContext context) async {
    int currentYear = DateTime.now().year;

    List<Widget> widgets = List.generate(3, (int value) {
      int year = currentYear - value;
      return ListTile(
          title: FlatButton(
        child: Text(year.toString(), textAlign: TextAlign.center),
        onPressed: () {
          Navigator.of(context).pop(year);
        },
      ));
    }).toList();

    int result = await showModalBottomSheet<int>(
        context: context,
        builder: (BuildContext contextModal) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: widgets,
          );
        });

    return result;
  }