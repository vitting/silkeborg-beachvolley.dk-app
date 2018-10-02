import 'dart:async';

import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/confirm_dialog_action_enum.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/helpers/enrollmentExists.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/helpers/enrollment_user_data_class.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import "../../../helpers/confirm_dialog_functions.dart" as confirmDialogFunctions;

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

Future<bool> checkIfMemberExistsAndSave(BuildContext context, EnrollmentUserData user) async {
    bool value = true;
    if (Home.loggedInUser != null) {
      EnrollmentExists enrollmentExists = await user.checkIfValuesExists();

      if (enrollmentExists.emailExists || enrollmentExists.phoneExists) {
        ConfirmDialogAction result = await confirmDialogFunctions.confirmDialog(
            context,
            title: Text("Info"),
            actionLeft: ConfirmDialogAction.no,
            actionRight: ConfirmDialogAction.yes,
            body: <Widget>[
              _getDialogText(enrollmentExists),
              Text("Vil du fortsætte med at oprette medlemmet?")
            ]);

        result == ConfirmDialogAction.yes ? value = true : value = false;
      }
    }

    return value;
  }

Text _getDialogText(EnrollmentExists enrollmentExists) {
    String text =
        "Der er allerede oprettet [MEMBERCOUNT] [MEMBEREMAIL][MEMEBERAND][MEMBERPHONE].";
    text = enrollmentExists.emailCount > 1 || enrollmentExists.phoneCount > 1
        ? text.replaceFirst("[MEMBERCOUNT]", "flere medlemmer")
        : text.replaceFirst("[MEMBERCOUNT]", "et medlem");
    text = enrollmentExists.emailExists
        ? text.replaceFirst("[MEMBEREMAIL]", "under den angivne e-mail adresse")
        : text.replaceFirst("[MEMBEREMAIL]", "");
    text = enrollmentExists.emailExists && enrollmentExists.phoneExists
        ? text.replaceFirst("[MEMEBERAND]", " og ")
        : text.replaceFirst("[MEMEBERAND]", "");
    text = enrollmentExists.phoneExists
        ? text.replaceFirst("[MEMBERPHONE]", " under det angivne mobilnummer")
        : text.replaceFirst("[MEMBERPHONE]", "");

    return Text(text);
  }