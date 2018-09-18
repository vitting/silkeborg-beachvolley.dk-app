import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_firestore.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_data.dart';

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
    name: Home.loggedInUser.displayName
  );

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(15.0),
                child: Column(
          children: <Widget>[
            Text("Velkommen til Ranglisten for Silkeborg Beachvolley."),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                  "Før du kan gå i gang med at registere dine kampe skal vi lige vide et par ting om dig."),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("Du kan altid senere ændre dine oplysninger i indstillinger."),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CircleAvatar(
                // child: Icon(Icons.add_photo_alternate),
                radius: 30.0,
                backgroundImage: CachedNetworkImageProvider(_rankingPlayerData.photoUrl),
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
            ),
            RaisedButton.icon(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  _savePlayer();
                  widget.onPressedValue(true);
                }
              },
              label: Text("Opret mig"),
              icon: Icon(Icons.check_circle),
            )
          ],
        ),
      );
  }

  void _savePlayer() async {
    await RankingFirestore.savePlayer(_rankingPlayerData); 
    Navigator.of(context).pop();
  }
}
