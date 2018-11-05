import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_widget.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'package:silkeborgbeachvolley/ui/write_to_sbv/helpers/write_to_data.dart';
import 'package:silkeborgbeachvolley/ui/write_to_sbv/helpers/write_to_row.dart';
import 'package:silkeborgbeachvolley/ui/write_to_sbv/helpers/write_to_textfield_widget.dart';

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        appBarBackgroundColor: Colors.blueGrey[800],
        title: "Besked",
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

                                WriteToData docReply = WriteToData.fromMap(snapshotReply.data.documents[position].data);
                                return Padding(
                                  padding: docReply.fromUserId == Home.loggedInUser.uid ? const EdgeInsets.only(left: 20.0) : const EdgeInsets.only(right: 20.0),
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
                    onTextFieldSubmit: (String value) {
                      _save(value);
                    },
                  )),
                )
              ],
            );
          },
        ));
  }

  void _save(String message) async {
    if (message != null && message.trim().isNotEmpty) {
      WriteToData replyData = WriteToData(
        type: "reply",
        messageRepliedToId: widget.item.id,
        message: message.trim(),
      );

      replyData.save();
    }
  }
}
