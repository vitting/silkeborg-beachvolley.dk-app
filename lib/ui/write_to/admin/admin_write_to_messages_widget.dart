import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/confirm_dialog_action_enum.dart';
import 'package:silkeborgbeachvolley/helpers/dialogs_class.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_widget.dart';
import 'package:silkeborgbeachvolley/ui/helpers/no_data_widget.dart';
import 'package:silkeborgbeachvolley/ui/write_to/admin/admin_write_to_detail_main.dart';
import 'package:silkeborgbeachvolley/ui/write_to/helpers/write_to_data.dart';
import 'package:silkeborgbeachvolley/ui/write_to/helpers/write_to_row.dart';

class AdminWriteToMessages extends StatefulWidget {
  @override
  AdminWriteToMessagesState createState() {
    return new AdminWriteToMessagesState();
  }
}

class AdminWriteToMessagesState extends State<AdminWriteToMessages> {
  Future<List<WriteToData>> list;
  @override
  Widget build(BuildContext context) {
    list = WriteToData.getAllMessagesReceived();
    return FutureBuilder(
        future: list,
        builder: (BuildContext context, AsyncSnapshot<List<WriteToData>> snapshot) {
          if (!snapshot.hasData) return LoaderSpinner();
          if (snapshot.hasData && snapshot.data.length == 0)
            return NoData(FlutterI18n.translate(
                context, "writeTo.adminWriteToMessages.string1"));

          return RefreshIndicator(
            backgroundColor: Colors.deepOrange[700],
            color: Colors.white,
            onRefresh: () {
              setState(() {
              list = WriteToData.getAllMessagesReceived();
            });
            return Future.value(true);
            },
            child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int position) {
              return WriteToRow(
                item: snapshot.data[position],
                showSettings: true,
                isAdmin: true,
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
          ),
          );
        },
      );
  }

  Future<bool> _deleteMessage(BuildContext context) async {
    bool value = false;
    int result = await Dialogs.modalBottomSheet(context, [
      DialogsModalBottomSheetItem(
          FlutterI18n.translate(context, "writeTo.adminWriteToMessages.string2"),
          Icons.delete,
          0)
    ]);

    if (result != null && result == 0) {
      ConfirmDialogAction action = await Dialogs.confirmDelete(context,
          FlutterI18n.translate(context, "writeTo.adminWriteToMessages.string3"));

      if (action != null && action == ConfirmDialogAction.delete) {
        value = true;
      }
    }

    return value;
  }
}