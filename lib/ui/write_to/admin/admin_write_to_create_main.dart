import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:silkeborgbeachvolley/helpers/circle_profile_image.dart';
import 'package:silkeborgbeachvolley/helpers/config_data.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_theme.dart';
import 'package:silkeborgbeachvolley/helpers/user_info_data.dart';
import 'package:silkeborgbeachvolley/ui/main_inheretedwidget.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_overlay_widget.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'package:silkeborgbeachvolley/ui/write_to/helpers/write_to_create_fab_widget.dart';
import 'package:silkeborgbeachvolley/ui/write_to/helpers/write_to_data.dart';
import 'package:validate/validate.dart';

class AdminWriteToCreate extends StatefulWidget {
  static final String routeName = "/writetocreate";
  final WriteToCreateFabType type;

  const AdminWriteToCreate({Key key, this.type}) : super(key: key);
  @override
  AdminWriteToCreateState createState() {
    return new AdminWriteToCreateState();
  }
}

class AdminWriteToCreateState extends State<AdminWriteToCreate> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  ConfigData _config;
  bool _saving = false;
  String _savingText = "";
  WriteToData _writeToData;

  @override
    void didChangeDependencies() {
      super.didChangeDependencies();

      _writeToData = WriteToData(
        type: "admin",
        newMessageStatus: true,
        subType: widget.type == WriteToCreateFabType.mail ? "mail" : "message",
        fromEmail: MainInherited.of(context).config.clubEmail,
        fromName: MainInherited.of(context).config.clubName,
        fromPhotoUrl: "locale",
        fromUserId: "",
        sendToEmail: "",
        sendToName: "",
        sendToPhotoUrl: "public",
        sendToEmailSubject: "",
        sendToUserId: "",
        message: "",
        messageRepliedToId: null);
    }

  @override
  Widget build(BuildContext context) {
    _config = MainInherited.of(context).config;
    if (MainInherited.of(context).modeProfile == SystemMode.develop) {
      _writeToData.sendToEmail = _config.emailDebug;
    }

    return SilkeborgBeachvolleyScaffold(
        title: _getTitle(context),
        body: Builder(
          builder: (BuildContext context) {
            return LoaderSpinnerOverlay(
              text: _savingText,
              show: _saving,
              child: Card(
                  child: Container(
                padding: EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      _getFormFields(),
                      FlatButton.icon(
                        textColor: SilkeborgBeachvolleyTheme.buttonTextColor,
                        icon: const Icon(Icons.send),
                        label: Text(_getButtonText()),
                        onPressed: () async {
                          setState(() {
                            _savingText = FlutterI18n.translate(context,
                                "writeTo.adminWriteToCreateMain.string1");
                            _saving = true;
                          });

                          final bool saveResult = await _save();
                          if (saveResult) {
                            if (widget.type == WriteToCreateFabType.mail) {
                              final bool sendResult = await _sendMail(context);
                              _writeToData.setSendEmailStatus(sendResult);
                            }

                            Navigator.of(context).pop();
                          } else {
                            setState(() {
                            _saving = false;
                          });
                          }
                        },
                      )
                    ],
                  ),
                ),
              )),
            );
          },
        ));
  }

  Widget _getFormFields() {
    List<Widget> widgets = [];
    switch (widget.type) {
      case WriteToCreateFabType.people:
        widgets.add(_nameField());
        widgets.add(_messageField());
        break;
      case WriteToCreateFabType.mail:
        widgets.add(_emailField());
        widgets.add(_subjectField());
        widgets.add(_messageField());
        break;
    }

    return Column(
      children: widgets,
    );
  }

  TextFormField _nameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
          labelText: FlutterI18n.translate(
              context, "writeTo.adminWriteToCreateMain.string2"),
          suffixIcon: IconButton(
            color: SilkeborgBeachvolleyTheme.buttonTextColor,
            icon: Icon(Icons.person),
            onPressed: () {
              _peopleChooser(context);
            },
          )),
      inputFormatters: [LengthLimitingTextInputFormatter(50)],
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onSaved: (String value) {
        _writeToData.sendToName = value.trim();
      },
      validator: (String value) {
        if (value.trim().isEmpty || _writeToData.sendToUserId.isEmpty)
          return FlutterI18n.translate(
              context, "writeTo.adminWriteToCreateMain.string3");
      },
    );
  }

  TextFormField _subjectField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: FlutterI18n.translate(
            context, "writeTo.adminWriteToCreateMain.string4"),
      ),
      inputFormatters: [LengthLimitingTextInputFormatter(50)],
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onSaved: (String value) {
        _writeToData.sendToEmailSubject = value.trim();
      },
      validator: (String value) {
        if (value.isEmpty)
          return FlutterI18n.translate(
              context, "writeTo.adminWriteToCreateMain.string5");
      },
    );
  }

  TextFormField _emailField() {
    return TextFormField(
      initialValue: _writeToData.sendToEmail,
      decoration: InputDecoration(
          labelText: FlutterI18n.translate(
              context, "writeTo.adminWriteToCreateMain.string6")),
      inputFormatters: [LengthLimitingTextInputFormatter(50)],
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onSaved: (String value) {
        _writeToData.sendToEmail = value.trim();
      },
      validator: (String value) {
        if (value.isEmpty)
          return FlutterI18n.translate(
              context, "writeTo.adminWriteToCreateMain.string7");
        try {
          Validate.isEmail(value.trim());
        } catch (e) {
          return FlutterI18n.translate(
              context, "writeTo.adminWriteToCreateMain.string8");
        }
      },
    );
  }

  TextFormField _messageField() {
    return TextFormField(
      maxLines: 10,
      initialValue: _writeToData.message,
      decoration: InputDecoration(
          labelText: FlutterI18n.translate(
              context, "writeTo.adminWriteToCreateMain.string9")),
      maxLength: 1000,
      onSaved: (String value) {
        _writeToData.message = value.trim();
      },
      validator: (String value) {
        if (value.trim().isEmpty) {
          return FlutterI18n.translate(
              context, "writeTo.adminWriteToCreateMain.string10");
        }
      },
    );
  }

  Future<bool> _sendMail(BuildContext context) async {
    bool value = false;

    final String emailFromName = _config.emailFromName;
    final String emailUsername = _config.emailUsername;
    final String emailPassword = _config.emailPassword;
    final Address fromAddress = Address(emailUsername, emailFromName);
    final smtpServer = gmail(emailUsername, emailPassword);
    final Message message = Message()
      ..from = fromAddress
      ..recipients.add(Address(_writeToData.sendToEmail))
      ..subject = _writeToData.sendToEmailSubject
      ..text = _writeToData.message;
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

  Future<bool> _save() async {
    bool value = false;
    if (_formKey.currentState.validate()) {
      value = true;
      _formKey.currentState.save();
      _writeToData.fromUserId = MainInherited.of(context).loggedInUser.uid;
      await _writeToData.save();
    }

    return value;
  }

  String _getTitle(BuildContext context) {
    String value = "";
    if (widget.type == WriteToCreateFabType.mail)
      value = FlutterI18n.translate(
          context, "writeTo.adminWriteToCreateMain.title1");
    if (widget.type == WriteToCreateFabType.people)
      value = FlutterI18n.translate(
          context, "writeTo.adminWriteToCreateMain.title2");
    return value;
  }

  String _getButtonText() {
    String value = "";
    if (widget.type == WriteToCreateFabType.mail)
      value = FlutterI18n.translate(
          context, "writeTo.adminWriteToCreateMain.string11");
    if (widget.type == WriteToCreateFabType.people)
      value = FlutterI18n.translate(
          context, "writeTo.adminWriteToCreateMain.string12");
    return value;
  }

  void _peopleChooser(BuildContext context) async {
    List<UserInfoData> users = await UserInfoData.getAllUsers();
    UserInfoData selectedUser = await showDialog<UserInfoData>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext contextModal) => SimpleDialog(
              title: Text(FlutterI18n.translate(
                  context, "writeTo.adminWriteToCreateMain.string13")),
              children: users.map<Widget>((UserInfoData user) {
                if (user.id == MainInherited.of(context).userId)
                  return Container();
                return ListTile(
                  onTap: () {
                    Navigator.of(contextModal).pop(user);
                  },
                  title: Row(
                    children: <Widget>[
                      CircleProfileImage(url: user.photoUrl),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(user.name, overflow: TextOverflow.ellipsis),
                      ))
                    ],
                  ),
                );
              }).toList(),
            ));

    if (selectedUser != null) {
      _writeToData.sendToUserId = selectedUser.id;
      _writeToData.sendToName = selectedUser.name;
      _writeToData.sendToEmail = selectedUser.email;
      _writeToData.sendToPhotoUrl = selectedUser.photoUrl;
      _nameController.text = selectedUser.name;
    }
  }
}
