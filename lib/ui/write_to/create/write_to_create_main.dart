import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_theme.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'package:silkeborgbeachvolley/ui/write_to/helpers/write_to_data.dart';
import 'package:validate/validate.dart';

class WriteToCreate extends StatefulWidget {
  static final String routeName = "/writetocreate";
  @override
  WriteToCreateState createState() {
    return new WriteToCreateState();
  }
}

class WriteToCreateState extends State<WriteToCreate> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  WriteToData _writeToData;

  @override
  void initState() {
    super.initState();
    _writeToData = WriteToData(
        type: "public",
        fromEmail: Home.loggedInUser != null ? Home.loggedInUser.email : "",
        message: "",
        fromName:
            Home.loggedInUser != null ? Home.loggedInUser.displayName : "",
        messageRepliedToId: null);
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
      title: "Skriv til os",
      body: Card(
          child: Container(
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _writeToData.fromName,
                decoration: InputDecoration(labelText: "Dit navn"),
                inputFormatters: [LengthLimitingTextInputFormatter(50)],
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                onSaved: (String value) {
                  _writeToData.fromName = value;
                },
                validator: (String value) {
                  if (value.isEmpty) return "Udfyld dit navn";
                },
              ),
              Home.loggedInUser == null
                  ? TextFormField(
                      initialValue: _writeToData.fromEmail,
                      decoration: InputDecoration(labelText: "E-mail"),
                      inputFormatters: [LengthLimitingTextInputFormatter(50)],
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onSaved: (String value) {
                        _writeToData.fromEmail = value;
                      },
                      validator: (String value) {
                        if (value.isEmpty) return "Udfyld e-mail";
                        try {
                          Validate.isEmail(value.trim());
                        } catch (e) {
                          return "E-mail er ikke valid";
                        }
                      },
                    )
                  : Container(),
              TextFormField(
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
              ),
              FlatButton.icon(
                textColor: SilkeborgBeachvolleyTheme.buttonTextColor,
                icon: Icon(Icons.send),
                label: Text("Send besked"),
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
        ),
      )),
    );
  }
}
