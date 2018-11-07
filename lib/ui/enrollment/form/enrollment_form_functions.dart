import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/confirm_dialog_action_enum.dart';
import 'package:silkeborgbeachvolley/main_inheretedwidget.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/helpers/enrollmentExists.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/helpers/enrollment_user_data_class.dart';
import "../../../helpers/confirm_dialog_functions.dart"
    as confirmDialogFunctions;

Future<DateTime> selectDate(BuildContext context, DateTime date) {
  DateTime calendarDate = DateTime.now();

  if (date != null) calendarDate = date;

  return showDatePicker(
      context: context,
      initialDate: calendarDate,
      firstDate: DateTime(1940),
      lastDate: DateTime(DateTime.now().year + 1),
      initialDatePickerMode: DatePickerMode.year);
}

Future<bool> checkIfMemberExistsAndSave(
    BuildContext context, EnrollmentUserData user) async {
  bool value = true;
  if (MainInherited.of(context).loggedInUser != null) {
    EnrollmentExists enrollmentExists = await user.checkIfValuesExists();

    if (enrollmentExists.emailExists || enrollmentExists.phoneExists) {
      ConfirmDialogAction result = await confirmDialogFunctions.confirmDialog(
          context,
          title: Text(FlutterI18n.translate(
              context, "enrollment.enrollmentFormFunctions.string1")),
          actionLeft: ConfirmDialogAction.no,
          actionRight: ConfirmDialogAction.yes,
          body: <Widget>[
            _getDialogText(context, enrollmentExists),
            Text(FlutterI18n.translate(
                context, "enrollment.enrollmentFormFunctions.string2"))
          ]);

      result == ConfirmDialogAction.yes ? value = true : value = false;
    }
  }

  return value;
}

Text _getDialogText(BuildContext context, EnrollmentExists enrollmentExists) {
  String text =
      "${FlutterI18n.translate(context, "enrollment.enrollmentFormFunctions.string3")} [MEMBERCOUNT] [MEMBEREMAIL][MEMEBERAND][MEMBERPHONE].";
  text = enrollmentExists.emailCount > 1 || enrollmentExists.phoneCount > 1
      ? text.replaceFirst(
          "[MEMBERCOUNT]",
          FlutterI18n.translate(
              context, "enrollment.enrollmentFormFunctions.string4"))
      : text.replaceFirst(
          "[MEMBERCOUNT]",
          FlutterI18n.translate(
              context, "enrollment.enrollmentFormFunctions.string5"));
  text = enrollmentExists.emailExists
      ? text.replaceFirst(
          "[MEMBEREMAIL]",
          FlutterI18n.translate(
              context, "enrollment.enrollmentFormFunctions.string6"))
      : text.replaceFirst("[MEMBEREMAIL]", "");
  text = enrollmentExists.emailExists && enrollmentExists.phoneExists
      ? text.replaceFirst(
          "[MEMEBERAND]",
          FlutterI18n.translate(
              context, "enrollment.enrollmentFormFunctions.string7"))
      : text.replaceFirst("[MEMEBERAND]", "");
  text = enrollmentExists.phoneExists
      ? text.replaceFirst(
          "[MEMBERPHONE]",
          FlutterI18n.translate(
              context, "enrollment.enrollmentFormFunctions.string8"))
      : text.replaceFirst("[MEMBERPHONE]", "");

  return Text(text);
}
