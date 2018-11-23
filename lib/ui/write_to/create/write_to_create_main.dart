import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_theme.dart';
import 'package:silkeborgbeachvolley/ui/main_inheretedwidget.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'package:silkeborgbeachvolley/ui/write_to/helpers/write_to_data.dart';
import 'package:validate/validate.dart';

class WriteToCreate extends StatefulWidget {
  static final String routeName = "/writetocreate";
  final FirebaseUser user;

  const WriteToCreate({Key key, @required this.user}) : super(key: key);
  @override
  WriteToCreateState createState() {
    return new WriteToCreateState();
  }
}

class WriteToCreateState extends State<WriteToCreate> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  WriteToData _writeToData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _writeToData = WriteToData(
      type: "public",
      newMessageStatus: true,
      subType: widget.user != null ? "message" : "mail",
      fromEmail: widget.user != null ? widget.user.email : "",
      fromName: widget.user != null ? widget.user.displayName : "",
      fromPhotoUrl: widget.user != null ? widget.user.photoUrl : "public",
      fromUserId: widget.user != null ? widget.user.uid : "",
      sendToPhotoUrl: "locale",
      sendToName: MainInherited.of(context).config.clubName,
      sendToEmail: MainInherited.of(context).config.clubEmail,
      sendToEmailSubject: "",
      sendToUserId: "",
      message: "",
      messageRepliedToId: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
      title: FlutterI18n.translate(context, "writeTo.writeToCreateMain.title"),
      body: Card(
          child: Container(
              padding: EdgeInsets.all(10.0),
              child: ListView(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          initialValue: _writeToData.fromName,
                          decoration: InputDecoration(
                              labelText: FlutterI18n.translate(context,
                                  "writeTo.writeToCreateMain.string1")),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50)
                          ],
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          onSaved: (String value) {
                            _writeToData.fromName = value.trim();
                          },
                          validator: (String value) {
                            if (value.isEmpty)
                              return FlutterI18n.translate(
                                  context, "writeTo.writeToCreateMain.string2");
                          },
                        ),
                        MainInherited.of(context).loggedInUser == null
                            ? TextFormField(
                                initialValue: _writeToData.fromEmail,
                                decoration: InputDecoration(
                                    labelText: FlutterI18n.translate(context,
                                        "writeTo.writeToCreateMain.string3")),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(50)
                                ],
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                onSaved: (String value) {
                                  _writeToData.fromEmail = value.trim();
                                },
                                validator: (String value) {
                                  if (value.isEmpty)
                                    return FlutterI18n.translate(context,
                                        "writeTo.writeToCreateMain.string4");
                                  try {
                                    Validate.isEmail(value.trim());
                                  } catch (e) {
                                    return FlutterI18n.translate(context,
                                        "writeTo.writeToCreateMain.string5");
                                  }
                                },
                              )
                            : Container(),
                        TextFormField(
                          maxLines: 10,
                          initialValue: _writeToData.message,
                          decoration: InputDecoration(
                              labelText: FlutterI18n.translate(context,
                                  "writeTo.writeToCreateMain.string6")),
                          maxLength: 500,
                          onSaved: (String value) {
                            _writeToData.message = value.trim();
                          },
                          validator: (String value) {
                            if (value.isEmpty)
                              return FlutterI18n.translate(
                                  context, "writeTo.writeToCreateMain.string7");
                          },
                        ),
                        FlatButton.icon(
                          textColor: SilkeborgBeachvolleyTheme.buttonTextColor,
                          icon: Icon(Icons.send),
                          label: Text(FlutterI18n.translate(
                              context, "writeTo.writeToCreateMain.string8")),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              await _writeToData.save();
                              Navigator.of(context).pop();
                            }
                          },
                        )
                      ],
                    ),
                  )
                ],
              ))),
    );
  }
}
