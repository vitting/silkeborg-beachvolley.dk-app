import 'package:flutter/material.dart';
import 'dart:convert';
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
  // GlobalKey<FormState> _formState = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        title: "test",
        body: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () async {
                try {
                String data = await DefaultAssetBundle.of(context).loadString("assets/files/config2.json");
                Map<String, dynamic> jsonData = json.decode(data);
                print(jsonData["mail"]);  
                } catch (e) {
                  print(e);
                }
                
              },
              child: Text("TEST"),
            )
          ],
        ));
  }
}
