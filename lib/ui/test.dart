import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
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
                child: Text("TEST"),
                onPressed: () async {
                  print(FlutterI18n.translate(context, "bulletin.photoAddPhotoWidget.title"));                  
                },
              )
            ],
          ),
        ));
  }
}
