import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_data_class.dart';
import 'package:silkeborgbeachvolley/ui/settings/helpers/settings_data_class.dart';

class RankingFirstTime extends StatefulWidget {
  final ValueChanged<bool> onPressedValue;
  @override
  _RankingFirstTimeState createState() => _RankingFirstTimeState();
  RankingFirstTime({@required this.onPressedValue});
}

class _RankingFirstTimeState extends State<RankingFirstTime> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  RankingPlayerData _rankingPlayerData = RankingPlayerData(
      userId: Home.loggedInUser.uid,
      photoUrl: Home.loggedInUser.photoUrl,
      name: Home.loggedInUser.displayName);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
      child: Column(
        children: <Widget>[
          Text("Velkommen til Ranglisten",
              textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              "Før du kan gå i gang med at registere dine kampe skal vi lige vide et par ting om dig. Du kan altid senere ændre dine oplysninger i indstillinger.",
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: CircleAvatar(
              radius: 30.0,
              backgroundImage:
                  CachedNetworkImageProvider(_rankingPlayerData.photoUrl),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  initialValue: _rankingPlayerData.name,
                  onSaved: (String value) {
                    _rankingPlayerData.name = value.trim();
                  },
                  validator: (String value) {
                    if (value.isEmpty)
                      return "Du skal udfylde dit rangliste navn";
                  },
                  inputFormatters: [LengthLimitingTextInputFormatter(50)],
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
                          Row(
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
                            ],
                          ),
                          Row(
                            children: <Widget>[
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
                          )
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          FlatButton.icon(
            textColor: Colors.deepOrange[700],
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                _savePlayer();
                widget.onPressedValue(true);
              }
            },
            label: Text("Gem min profil"),
            icon: Icon(Icons.check_circle),
          )
        ],
      ),
    );
  }

  void _savePlayer() async {
    SettingsData settings = await SettingsData.get(_rankingPlayerData.userId);
    if (settings != null) {
      settings.rankingName = _rankingPlayerData.name;
      settings.sex = _rankingPlayerData.sex;
      settings.save();
    }
    await _rankingPlayerData.save();
    Navigator.of(context).pop();
  }
}
