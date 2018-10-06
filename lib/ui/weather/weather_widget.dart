import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Weather extends StatelessWidget {
  final bool showWind;
  Weather({this.showWind = false});

  factory Weather.withWind() {
    return Weather(showWind: true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _load(),
      builder: (BuildContext context, AsyncSnapshot<WeatherData> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) return Container();
        if (snapshot.hasData)
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("${snapshot.data.temperature}\u00b0"),
                showWind
                    ? Text(snapshot.data.wind, style: TextStyle(fontSize: 10.0))
                    : Container()
              ],
            ),
          );
      },
    );
  }
}

Future<WeatherData> _load() async {
  WeatherData data;
  final http.Response response =
      await http.get("http://vejr.eu/api.php?location=Silkeborg&degree=C");
  if (response.statusCode == 200) {
    Map<String, dynamic> bodyJson = json.decode(
        response.body.replaceFirst("<pre>", "").replaceAll("</pre>", ""));
    data = WeatherData.fromJson(bodyJson);
  }
  return data;
}

class WeatherData {
  String localtionName;
  String temperature;
  String sky;
  String wind;

  WeatherData({this.localtionName, this.sky, this.temperature, this.wind});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
        localtionName: json["LocationName"],
        sky: json["CurrentData"]["skyText"],
        temperature: json["CurrentData"]["temperature"],
        wind: json["CurrentData"]["windText"]);
  }
}
