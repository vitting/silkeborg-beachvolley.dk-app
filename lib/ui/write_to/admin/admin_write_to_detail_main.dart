import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:silkeborgbeachvolley/helpers/config_data.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_theme.dart';
import 'package:silkeborgbeachvolley/ui/main_inheretedwidget.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_widget.dart';
import 'package:silkeborgbeachvolley/ui/helpers/no_data_widget.dart';
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
  ConfigData _config;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _config = MainInherited.of(context).config;
  }

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
                        isAdmin: true,
                        item: widget.item,
                      ),
                      widget.item.type == "public" && widget.item.subType == "mail" ? Container(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        color: SilkeborgBeachvolleyTheme.headerBackground,
                        child: Text(FlutterI18n.translate(context, "writeTo.adminWriteToDetailMain.string3"), textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, color: Colors.white))
                      ) : Container(),
                      StreamBuilder(
                          stream: widget.item.getReplies(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshotReply) {
                            if (snapshotReply.hasError) {
                              print(snapshotReply.hasError);
                              return NoData(FlutterI18n.translate(context,
                                  "writeTo.adminWriteToDetailMain.string1"));
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
                                  padding: docReply.type == "public"
                                      ? const EdgeInsets.only(left: 20.0)
                                      : const EdgeInsets.only(right: 20.0),
                                  child: WriteToRow(
                                    isAdmin: true,
                                    isDetail: true,
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
                    isEmail: widget.item.subType == "mail",
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
      WriteToData replyItem = await _save(context, message, item);
      if (item.subType == "mail") {
        bool sendMailResult = await _sendMail(context, replyItem);
        replyItem.setSendEmailStatus(sendMailResult);
      }
    }

    return true;
  }

  Future<WriteToData> _save(
      BuildContext context, String message, WriteToData item) async {
    WriteToData replyData = WriteToData(
        type: "admin",
        newMessageStatus: true,
        subType: _getSubType(),
        fromEmail: _config.emailFromMail,
        fromName: _config.emailFromName,
        fromPhotoUrl: "locale",
        fromUserId: MainInherited.of(context).loggedInUser.uid,
        sendToEmail: item.fromEmail,
        sendToName: item.fromName,
        sendToPhotoUrl: item.fromPhotoUrl,
        sendToEmailSubject: FlutterI18n.translate(
            context, "writeTo.adminWriteToDetailMain.string2"),
        sendToUserId: item.fromUserId,
        message: message.trim(),
        messageRepliedToId: widget.item.id);

    await replyData.save();

    return replyData;
  }

  Future<bool> _sendMail(BuildContext context, WriteToData replyItem) async {
    bool value = false;
    final String emailFromName = _config.emailFromName;
    final String emailUsername = _config.emailUsername;
    final String emailPassword = _config.emailPassword;
    final Address fromAddress = Address(emailUsername, emailFromName);
    final Address sendToAddress =
        MainInherited.of(context).modeProfile == SystemMode.release
            ? Address(replyItem.sendToEmail)
            : Address(_config.emailDebug);
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
    String value =
        FlutterI18n.translate(context, "writeTo.adminWriteToDetailMain.title1");
    if (widget.item.subType == "mail") {
      value = FlutterI18n.translate(
          context, "writeTo.adminWriteToDetailMain.title2");
    }

    return value;
  }

  String _getSubType() {
    String value;
    if (widget.item.type == "admin") {
      if (widget.item.subType == "message") {
        value = "reply_message";
      } else {
        value = "reply_mail";
      }
    } else {
      if (widget.item.subType == "message") {
        value = "reply_message";
      } else {
        value = "reply_mail";
      }
    }

    return value;
  }
}
