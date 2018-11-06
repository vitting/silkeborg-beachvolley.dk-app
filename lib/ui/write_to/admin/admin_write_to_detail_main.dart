import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:silkeborgbeachvolley/helpers/system_helpers.dart';
import 'package:silkeborgbeachvolley/main_inheretedwidget.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_widget.dart';
import 'package:silkeborgbeachvolley/ui/helpers/no_data_widget.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'package:silkeborgbeachvolley/ui/write_to/helpers/write_to_data.dart';
import 'package:silkeborgbeachvolley/ui/write_to/helpers/write_to_row.dart';
import 'package:silkeborgbeachvolley/ui/write_to/helpers/write_to_textfield_widget.dart';

class AdminWriteToDetail extends StatefulWidget {
  final WriteToData item;

  const AdminWriteToDetail({Key key, this.item}) : super(key: key);
  @override
  AdminWriteToDetailState createState() {
    return new AdminWriteToDetailState();
  }
}

class AdminWriteToDetailState extends State<AdminWriteToDetail> {
  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        appBarBackgroundColor: Colors.blueGrey[800],
        title: _getTitle(),
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
                            if (snapshotReply.hasError) {
                              print(snapshotReply.hasError);
                              return NoData(FlutterI18n.translate(context, "writeTo.adminWriteToDetailMain.string1"));
                            }
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
                                  padding: docReply.fromUserId ==
                                          Home.loggedInUser.uid
                                      ? const EdgeInsets.only(
                                          left: 40.0, right: 10.0)
                                      : const EdgeInsets.only(
                                          right: 40.0, left: 10.0),
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
                      await _saveMain(context, value, widget.item);
                    },
                  )),
                )
              ],
            );
          },
        ));
  }

  Future<bool> _saveMain(
      BuildContext context, String message, WriteToData item) async {
    if (message.trim().isNotEmpty) {
      final Map<String, dynamic> config =
          await SystemHelpers.getConfig(context);
      WriteToData replyItem = await _save(message, item, config);
      if (item.sendToUserId == null) {
        bool sendMailResult = await _sendMail(context, replyItem, config);
        replyItem.setSendEmailStatus(sendMailResult);
      }
    }

    return true;
  }

  Future<WriteToData> _save(
      String message, WriteToData item, Map<String, dynamic> config) async {
    WriteToData replyData = WriteToData(
      type: "reply_locale",
      messageRepliedToId: widget.item.id,
      fromEmail: config["emailFromMail"],
      fromName: config["emailFromName"],
      fromPhotoUrl: "locale",
      sendToEmail: item.fromEmail,
      sendToName: item.fromName,
      sendToEmailSubject: FlutterI18n.translate(context, "writeTo.adminWriteToDetailMain.string2"),
      sendToUserId: item.fromUserId,
      message: message.trim(),
    );

    await replyData.save();

    return replyData;
  }

  Future<bool> _sendMail(BuildContext context, WriteToData replyItem,
      Map<String, dynamic> config) async {
    bool value = false;
    final String emailFromName = config["emailFromName"];
    final String emailUsername = config["emailUsername"];
    final String emailPassword = config["emailPassword"];
    final Address fromAddress = Address(emailUsername, emailFromName);
    final Address sendToAddress =
        MainInherited.of(context).modeProfile == SystemMode.release
            ? Address(replyItem.sendToEmail)
            : Address("cvn_vitting@hotmail.com");
    final smtpServer = gmail(emailUsername, emailPassword);
    final Message message = Message()
      ..from = fromAddress
      ..recipients.add(sendToAddress)
      ..subject = replyItem.sendToEmailSubject
      ..text = replyItem.message;

    List<SendReport> sendReport = await send(message, smtpServer);

    if (sendReport != null && sendReport.length != 0) {
      if (sendReport[0].sent) {
        value = true;
      } else {
        if (sendReport[0].validationProblems != null) {
          sendReport[0]
              .validationProblems
              .forEach((problem) => print(problem.msg));
        }
      }
    }

    return value;
  }

  String _getTitle() {
    String value = FlutterI18n.translate(context, "writeTo.adminWriteToDetailMain.title1");
    if (widget.item.fromUserId == null) {
      value = FlutterI18n.translate(context, "writeTo.adminWriteToDetailMain.title2");
    }

    return value;
  }
}
