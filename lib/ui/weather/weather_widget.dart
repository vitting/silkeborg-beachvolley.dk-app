import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Weather extends StatelessWidget {
  final bool showWind;
  const Weather({this.showWind = false});

  factory Weather.withWind() {
    return Weather(showWind: true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _load(),
      builder: (BuildContext context, AsyncSnapshot<WeatherData> snapshot) {
        if (!snapshot.hasData) return Container();
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
    data = await compute<String, WeatherData>(parseJson, response.body);
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
        localtionName: json["CurrentData"] == null ? "" : json["LocationName"],
        sky: json["CurrentData"] == null ? "" : json["CurrentData"]["skyText"],
        temperature: json["CurrentData"] == null
            ? ""
            : json["CurrentData"]["temperature"],
        wind:
            json["CurrentData"] == null ? "" : json["CurrentData"]["windText"]);
  }
}

WeatherData parseJson(String responseBody) {
  Map<String, dynamic> bodyJson = json
      .decode(responseBody.replaceFirst("<pre>", "").replaceAll("</pre>", ""));
  return WeatherData.fromJson(bodyJson);
}
