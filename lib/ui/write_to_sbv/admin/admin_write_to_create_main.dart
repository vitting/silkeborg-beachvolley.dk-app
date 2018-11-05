import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:silkeborgbeachvolley/helpers/circle_profile_image.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_constant.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_theme.dart';
import 'package:silkeborgbeachvolley/helpers/system_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/user_info_data.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_overlay_widget.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'package:silkeborgbeachvolley/ui/write_to_sbv/helpers/write_to_create_fab_widget.dart';
import 'package:silkeborgbeachvolley/ui/write_to_sbv/helpers/write_to_data.dart';
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
  bool _saving = false;
  String _savingText = "";
  WriteToData _writeToData;

  @override
  void initState() {
    super.initState();
    _writeToData = WriteToData(
        type: widget.type == WriteToCreateFabType.mail ? "mail" : "message",
        fromEmail: SilkeborgBeachvolleyConstants.email,
        fromName: SilkeborgBeachvolleyConstants.name,
        message: "",
        fromPhotoUrl: "",
        sendToEmail: "cvn_vitting@hotmail.com",

        ///CHRISTIAN: Replace with ""
        sendToName: "",
        messageRepliedToId: null);
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
      title: _getTitle(),
      body: LoaderSpinnerOverlay(
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
                      _savingText = "Sender besked";
                      _saving = true;
                    });

                    final bool saveResult = await _save(context);

                    if (saveResult &&
                        widget.type == WriteToCreateFabType.mail) {
                      final bool sendResult = await _sendMail(context);
                      _writeToData.setSendEmailStatus(sendResult);
                    }

                    setState(() {
                      _saving = false;
                    });
                    
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
        )),
      ),
    );
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
          labelText: "Navn",
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
        _writeToData.sendToName = value;
      },
      validator: (String value) {
        if (value.isEmpty) return "Udfyld navn";
      },
    );
  }

  TextFormField _subjectField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Emne",
      ),
      inputFormatters: [LengthLimitingTextInputFormatter(50)],
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onSaved: (String value) {
        _writeToData.sendToEmailSubject = value;
      },
      validator: (String value) {
        if (value.isEmpty) return "Udfyld emne";
      },
    );
  }

  TextFormField _emailField() {
    return TextFormField(
      initialValue: _writeToData.sendToEmail,
      decoration: InputDecoration(labelText: "E-mail"),
      inputFormatters: [LengthLimitingTextInputFormatter(50)],
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onSaved: (String value) {
        _writeToData.sendToEmail = value;
      },
      validator: (String value) {
        if (value.isEmpty) return "Udfyld e-mail";
        try {
          Validate.isEmail(value.trim());
        } catch (e) {
          return "E-mail er ikke valid";
        }
      },
    );
  }

  TextFormField _messageField() {
    return TextFormField(
      maxLines: 10,
      initialValue: _writeToData.message,
      decoration: InputDecoration(labelText: "Din besked"),
      maxLength: 1000,
      onSaved: (String value) {
        _writeToData.message = value;
      },
      validator: (String value) {
        if (value.isEmpty) return "Udfyld besked";
      },
    );
  }

  Future<bool> _sendMail(BuildContext context) async {
    bool value = false;
    final Map<String, dynamic> config = await SystemHelpers.getConfig(context);
    final String emailFromName = config["emailFromName"];
    final String emailUsername = config["emailUsername"];
    final String emailPassword = config["emailPassword"];
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

  Future<bool> _save(BuildContext context) async {
    bool value = false;
    if (_formKey.currentState.validate()) {
      value = true;
      _formKey.currentState.save();
      await _writeToData.save();
    }

    return value;
  }

  String _getTitle() {
    String value = "";
    if (widget.type == WriteToCreateFabType.mail) value = "Skriv e-mail";
    if (widget.type == WriteToCreateFabType.people) value = "Skriv besked";
    return value;
  }

  String _getButtonText() {
    String value = "";
    if (widget.type == WriteToCreateFabType.mail) value = "Send e-mail";
    if (widget.type == WriteToCreateFabType.people) value = "Send besked";
    return value;
  }

  void _peopleChooser(BuildContext context) async {
    List<UserInfoData> users = await UserInfoData.getAllUsers();
    UserInfoData selectedUser = await showDialog<UserInfoData>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext contextModal) => SimpleDialog(
              title: Text("Vælg bruger"),
              children: users.map<Widget>((UserInfoData user) {
                if (user.id == Home.loggedInUser.uid) return Container();
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
      _nameController.text = selectedUser.name;
    }
  }
}
