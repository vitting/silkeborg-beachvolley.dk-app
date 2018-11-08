import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/confirm_dialog_action_enum.dart';
import 'package:silkeborgbeachvolley/helpers/dialogs_class.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_widget.dart';
import 'package:silkeborgbeachvolley/ui/helpers/no_data_widget.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'package:silkeborgbeachvolley/ui/write_to/admin/admin_write_to_create_main.dart';
import 'package:silkeborgbeachvolley/ui/write_to/admin/admin_write_to_detail_main.dart';
import 'package:silkeborgbeachvolley/ui/write_to/helpers/write_to_create_fab_widget.dart';
import 'package:silkeborgbeachvolley/ui/write_to/helpers/write_to_data.dart';
import 'package:silkeborgbeachvolley/ui/write_to/helpers/write_to_row.dart';

class AdminWriteTo extends StatelessWidget {
  static final String routeName = "/adminwriteto";

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
      title: FlutterI18n.translate(context, "writeTo.adminWriteToMain.title"),
      floatingActionButton: WriteToCreateFab(
        onPressedValue: (WriteToCreateFabType type) {
          Navigator.of(context).push(MaterialPageRoute(
              fullscreenDialog: true,
              builder: (BuildContext context) =>
                  AdminWriteToCreate(type: type)));
        },
      ),
      body: StreamBuilder(
        stream: WriteToData.getAllMessages(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return LoaderSpinner();
          if (snapshot.hasData && snapshot.data.documents.length == 0)
            return NoData(FlutterI18n.translate(
                context, "writeTo.adminWriteToMain.string1"));

          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int position) {
              WriteToData doc =
                  WriteToData.fromMap(snapshot.data.documents[position].data);

              return WriteToRow(
                item: doc,
                showStatusIcons: true,
                showSettings: true,
                onSettingPressed: (WriteToData item) async {
                  bool delete = await _deleteMessage(context);
                  if (delete) {
                    item.delete();
                  }
                },
                onRowTap: (WriteToData item) {
                  if (item.type != "mail") {
                    Navigator.of(context).push(MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (BuildContext context) => AdminWriteToDetail(
                              item: item,
                            )));
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<bool> _deleteMessage(BuildContext context) async {
    bool value = false;
    int result = await Dialogs.modalBottomSheet(context, [
      DialogsModalBottomSheetItem(
          FlutterI18n.translate(context, "writeTo.adminWriteToMain.string2"),
          Icons.delete,
          0)
    ]);

    if (result != null && result == 0) {
      ConfirmDialogAction action = await Dialogs.confirmDelete(context,
          FlutterI18n.translate(context, "writeTo.adminWriteToMain.string3"));

      if (action != null && action == ConfirmDialogAction.delete) {
        value = true;
      }
    }

    return value;
  }
}
