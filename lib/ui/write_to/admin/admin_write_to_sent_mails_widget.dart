import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/dialogs_class.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_widget.dart';
import 'package:silkeborgbeachvolley/ui/helpers/no_data_widget.dart';
import 'package:silkeborgbeachvolley/ui/write_to/helpers/write_to_data.dart';
import 'package:silkeborgbeachvolley/ui/write_to/helpers/write_to_row.dart';

class AdminWriteToSentMails extends StatefulWidget {
  @override
  AdminWriteToSentMailsState createState() {
    return new AdminWriteToSentMailsState();
  }
}

class AdminWriteToSentMailsState extends State<AdminWriteToSentMails> {
  final ScrollController _scrollController = ScrollController();
  final _defaultNumberOfItemsToLoad = 20;
  int _numberOfItemsToLoad;
  int _currentLengthOfLoadedItems = 0;

@override
  void initState() {
    super.initState();
    _numberOfItemsToLoad = _defaultNumberOfItemsToLoad;
    _scrollController.addListener(_handleScrollLoadMore);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: WriteToData.getAllMessagesSentMailAsStream(_numberOfItemsToLoad),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return LoaderSpinner();
          if (snapshot.hasData && snapshot.data.documents.length == 0)
            return NoData(FlutterI18n.translate(
                context, "writeTo.adminWriteToSentMails.string1"));

          _currentLengthOfLoadedItems = snapshot.data.documents.length;
          return ListView.builder(
            controller: _scrollController,
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

  void _handleScrollLoadMore() {
    if (_scrollController.position.extentAfter == 0) {
      if (_currentLengthOfLoadedItems >= _numberOfItemsToLoad)
        setState(() {
          _numberOfItemsToLoad =
              _numberOfItemsToLoad + _defaultNumberOfItemsToLoad;
        });
    }
  }
}