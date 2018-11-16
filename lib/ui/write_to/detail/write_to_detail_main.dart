import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_constant.dart';
import 'package:silkeborgbeachvolley/ui/main_inheretedwidget.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_widget.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'package:silkeborgbeachvolley/ui/write_to/helpers/write_to_data.dart';
import 'package:silkeborgbeachvolley/ui/write_to/helpers/write_to_row.dart';
import 'package:silkeborgbeachvolley/ui/write_to/helpers/write_to_textfield_widget.dart';

class WriteToDetail extends StatefulWidget {
  final WriteToData item;

  const WriteToDetail({Key key, this.item}) : super(key: key);
  @override
  WriteToDetailState createState() {
    return new WriteToDetailState();
  }
}

class WriteToDetailState extends State<WriteToDetail> {
  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        appBarBackgroundColor: Colors.blueGrey[800],
        title:
            FlutterI18n.translate(context, "writeTo.writeToDetailMain.title"),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              children: <Widget>[
                Container(
                  color: Colors.blueGrey,
                  child: ListView(
                    children: <Widget>[
                      WriteToRow(
                        item: widget.item,
                      ),
                      StreamBuilder(
                          stream: widget.item.getReplies(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshotReply) {
                            if (!snapshotReply.hasData) return LoaderSpinner();
                            if (snapshotReply.hasData &&
                                snapshotReply.data.documents.length == 0)
                              return Container();

                            return ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount:
                                  snapshotReply.data.documents.length + 1,
                              itemBuilder:
                                  (BuildContext context, int position) {
                                if (position ==
                                    snapshotReply.data.documents.length) {
                                  return SizedBox(
                                    width: double.infinity,
                                    height: 65.0,
                                  );
                                }

                                WriteToData docReply = WriteToData.fromMap(
                                    snapshotReply
                                        .data.documents[position].data);
                                return Padding(
                                  padding: docReply.type == "admin"
                                      ? const EdgeInsets.only(left: 20.0)
                                      : const EdgeInsets.only(right: 20.0),
                                  child: WriteToRow(
                                    item: docReply,
                                  ),
                                );
                              },
                            );
                          }),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Align(
                      child: WriteToTextfield(
                    backgroundColor: Colors.blueGrey.withAlpha(140),
                    onTextFieldSubmit: (String value) async {
                      if (value.trim().isNotEmpty) {
                        await _save(context, value);
                      }
                    },
                  )),
                )
              ],
            );
          },
        ));
  }

  Future<WriteToData> _save(BuildContext context, String message) async {
    WriteToData replyData = WriteToData(
        type: "public",
        subType: "reply",
        newMessageStatus: true,
        fromEmail: MainInherited.of(context).loggedInUser.email,
        fromName: MainInherited.of(context).loggedInUser.displayName,
        fromPhotoUrl: MainInherited.of(context).loggedInUser.photoUrl,
        fromUserId: MainInherited.of(context).loggedInUser.uid,
        sendToEmailSubject: "",
        sendToUserId: "",
        sendToPhotoUrl: "locale",
        sendToEmail: SilkeborgBeachvolleyConstants.email,
        sendToName: SilkeborgBeachvolleyConstants.name,
        message: message.trim(),
        messageRepliedToId: widget.item.id);

    await replyData.save();

    return replyData;
  }
}
