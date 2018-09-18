import 'dart:async';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/userauth.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_data.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_sharedpref.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

class Settings extends StatefulWidget {
  static final routeName = "/settings";

  @override
  SettingsState createState() {
    return new SettingsState();
  }
}
//CHRISTIAN: HVORNÅR GEMMER VI INDSTILLINGERNE? i Dispose?
class SettingsState extends State<Settings> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  RankingPlayerData _rankingPlayerData = RankingPlayerData(
    userId: Home.loggedInUser.uid,
    photoUrl: Home.loggedInUser.photoUrl
  );
  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        title: "Silkeborg Beachvolley",
        body: Container(
          constraints: BoxConstraints.expand(),
          child: ListView(
            children: <Widget>[
              Card(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Rangliste spiller"),
                      Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                  TextFormField(
                    initialValue: Home.loggedInUser.displayName,
                    onSaved: (String value) {
                      _rankingPlayerData.name = value.trim();
                    },
                    validator: (String value) {
                      if (value.isEmpty) return "Du skal udfylde dit rangliste navn";
                    },
                    maxLength: 50,
                    decoration: InputDecoration(labelText: "Dit rangliste navn"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                    child: FormField(
                      onSaved: (String value) {
                        _rankingPlayerData.sex = value;
                      },
                      validator: (String value) {
                        if (value.isEmpty) return "Du skal vælge dit køn";
                      },
                      initialValue: "",  
                      builder: (FormFieldState<String> state) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text("Kvinde"),
                            Radio(
                              onChanged: (String value) {
                                setState(() {
                                  state.didChange(value);
                                });
                              },
                              groupValue: state.value,
                              value: "female",
                            ),
                            Text("Mand"),
                            Radio(
                              onChanged: (String value) {
                                setState(() {
                                  state.didChange(value);
                                });
                              },
                              groupValue: state.value,
                              value: "male",
                            )
                          ],
                        );
                      },
                    ),
                  ),
              ],
            ),
          )
                    ],
                  ),
                ),
              ),
              _logoutButton(context)
            ],
          )
        ));
  }

  Widget _logoutButton(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        _logutOnPressed(context);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.extension),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text("Log ud"),
          )
        ],
      ),
    );
  }

  Future<void> _logutOnPressed(context) async {
    bool value = await UserAuth.signOutWithFacebook();
    await RankingSharedPref.removeIsItFirstTime();
    Navigator.pop(context, value);
  }
}
