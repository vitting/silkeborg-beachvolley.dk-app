import 'dart:async';

import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/postcal_codes_data.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'package:silkeborgbeachvolley/ui/weather/weather_widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
              onPressed: () {
                _load();
              },
            )
          ],
        ),
      )
    );
  }

  void _load() async {
  final http.Response response =
      await http.get("https://dawa.aws.dk/postnumre");
  if (response.statusCode == 200) {
    List<dynamic> bodyJson = json.decode(response.body);
    List<PostalCode> list = bodyJson.map<PostalCode>((dynamic item) {
      return PostalCode.fromMap(item);
    }).toList();
    
    list.forEach((PostalCode item) {
      item.save();
    });
  }
}
}