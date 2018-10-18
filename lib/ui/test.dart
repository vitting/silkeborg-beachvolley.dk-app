import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/firebase_functions_call.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

class TestWidget extends StatefulWidget {
  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  
  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        title: "test",
        body: Container(
          child: Column(
            children: <Widget>[
              RaisedButton(
                onPressed: () async {
                  String result = await FirebaseFunctions.resetRanking();
                  print("FUNCTIONS: $result");
                },
              )
            ],
          ),
        ));
  }
}
