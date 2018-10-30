import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/livescore/create/helpers/livescore_sharedpref.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

List<String> names = [
  "Christian Nicolaisen",
  "Allan Nielsen",
  "Mads Langer",
  "Mogens Kjeldsen",
  "Hanne Jense",
  "Kim Nielsen"
];

class TestWidget extends StatefulWidget {
  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  GlobalKey<FormState> _formState = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    List<String> names2 = await LivescoreSharedPref.getPlayerNames();
    print(names2);
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        title: "test",
        body: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () {},
              child: Text("TEST"),
            ),
           Form(
             key: _formState,
             child: Column(
               children: <Widget>[
                 Stack(
               children: <Widget>[
                 TextFormField(
                   initialValue: "",
                   onSaved: (String value) {
                     print("SAVE: $value");
                   },
                   validator: (String value) {
                     if (value.isEmpty) return "Der er en fejl";
                   },
                 )
               ],
             ),
               ],
             )
           )
          ],
        ));
  }
}
