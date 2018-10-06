import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:silkeborgbeachvolley/helpers/chip_header.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'package:silkeborgbeachvolley/ui/settings/helpers/settings_data_class.dart';

class Settings extends StatefulWidget {
  static final routeName = "/settings";

  @override
  SettingsState createState() {
    return new SettingsState();
  }
}

class SettingsState extends State<Settings> {
  SettingsData _settingsData;
  bool _showWeatherState = false;
  TextEditingController _rankingNameController = TextEditingController();
  String _rankingNameError;
  Color _rankingNameColor;
  String _sexValue;
  @override
  void initState() {
    super.initState();
    _getSettings();
  }

  _getSettings() async {
    _settingsData = await SettingsData.get(Home.loggedInUser.uid);
    if (mounted) {
      setState(() {
        _showWeatherState = _settingsData.showWeather;
        if (_settingsData.rankingName.isNotEmpty) {
          _rankingNameController.value =
              TextEditingValue(text: _settingsData.rankingName);
        } else {
          _rankingNameController.value =
              TextEditingValue(text: Home.loggedInUser.displayName);
        }

        _sexValue = _settingsData.sex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(title: "Indstillinger", body: _main());
  }

  _main() {
    return Container(
      child: ListView(
        children: <Widget>[
          Card(
            child: Container(
              padding: EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ChipHeader("Vejret"),
                  _showWeather(),
                ],
              ),
            ),
          ),
          Card(
            child: Container(
              padding: EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ChipHeader("Ranglisten"),
                  _rankingName(),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: _sex(),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _showWeather() {
    return SwitchListTile(
      onChanged: (bool state) async {
        _settingsData.showWeather = state;
        _settingsData.save();

        if (mounted) {
          setState(() {
            _showWeatherState = state;
          });
        }
      },
      value: _showWeatherState,
      title: Text("Vis vejret"),
    );
  }

  Widget _rankingName() {
    return TextField(
      controller: _rankingNameController,
      keyboardType: TextInputType.text,
      inputFormatters: [LengthLimitingTextInputFormatter(50)],
      decoration: InputDecoration(
          errorText: _rankingNameError,
          labelText: "Rangliste navn",
          suffixIcon: Icon(Icons.check_circle, color: _rankingNameColor)),
      onSubmitted: (String value) {
        String error;
        Color color = Colors.green;
        if (value.isEmpty) {
          error = "Rangliste navn skal være udfyldt";
          color = Colors.red;
        } else {
          _settingsData.rankingName = value;
          _settingsData.save();
        }

        if (mounted) {
          setState(() {
            _rankingNameColor = color;
            _rankingNameError = error;
          });
        }
      },
    );
  }

  Widget _sex() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Køn", style: TextStyle(fontSize: 16.0)),
            _sexElement("Kvinde", "female"),
            _sexElement("Mand", "male")
          ],
        ),
      ],
    );
  }

  Widget _sexElement(String text, String radioValue) {
    return Row(
      children: <Widget>[
        Radio(
          groupValue: _sexValue,
          value: radioValue,
          onChanged: (String value) async {
            _settingsData.sex = value;
            _settingsData.save();
            if (mounted) {
              setState(() {
                _sexValue = value;
              });
            }
          },
        ),
        Text(text),
      ],
    );
  }
}
