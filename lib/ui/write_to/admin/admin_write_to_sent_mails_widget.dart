import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/confirm_dialog_action_enum.dart';
import 'package:silkeborgbeachvolley/helpers/dialogs_class.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_widget.dart';
import 'package:silkeborgbeachvolley/ui/helpers/no_data_widget.dart';
import 'package:silkeborgbeachvolley/ui/write_to/helpers/write_to_data.dart';
import 'package:silkeborgbeachvolley/ui/write_to/helpers/write_to_row.dart';

class AdminWriteToSentMails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: WriteToData.getAllMessagesSentMail(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return LoaderSpinner();
          if (snapshot.hasData && snapshot.data.documents.length == 0)
            return NoData(FlutterI18n.translate(
                context, "writeTo.adminWriteToSentMails.string1"));

          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int position) {
              WriteToData doc =
                  WriteToData.fromMap(snapshot.data.documents[position].data);

              return WriteToRow(
                item: doc,
                isAdmin: true,
                showSettings: true,
                onSettingPressed: (WriteToData item) async {
                  bool delete = await _deleteMessage(context);
                  if (delete) {
                    item.delete();
                  }
                },
              );
            },
          );
        },
      );
  }

  Future<bool> _deleteMessage(BuildContext context) async {
    bool value = false;
    int result = await Dialogs.modalBottomSheet(context, [
      DialogsModalBottomSheetItem(
          FlutterI18n.translate(context, "writeTo.adminWriteToSentMails.string2"),
          Icons.delete,
          0)
    ]);

    if (result != null && result == 0) {
      ConfirmDialogAction action = await Dialogs.confirmDelete(context,
          FlutterI18n.translate(context, "writeTo.adminWriteToSentMails.string3"));

      if (action != null && action == ConfirmDialogAction.delete) {
        value = true;
      }
    }

    return value;
  }

}