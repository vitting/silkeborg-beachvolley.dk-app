import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/ui/helpers/chip_header_widget.dart';
import 'package:silkeborgbeachvolley/helpers/notification_categories_enum.dart';
import 'package:silkeborgbeachvolley/helpers/user_messaging_data.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'package:silkeborgbeachvolley/ui/settings/helpers/settings_data.dart';

class Settings extends StatefulWidget {
  static final routeName = "/settings";

  @override
  SettingsState createState() {
    return new SettingsState();
  }
}

class SettingsState extends State<Settings> {
  SettingsData _settingsData;
  UserMessagingData _messagingData;
  bool _showWeatherState = false;
  bool _notificationsNews = false;
  bool _notificationsEvent = false;
  bool _notificationsPlay = false;
  TextEditingController _rankingNameController = TextEditingController();
  String _rankingNameError;
  Color _rankingNameColor;
  String _sexValue;

  @override
  void initState() {
    super.initState();
    _getSettings();
  }

  Future<Null> _getSettings() async {
    _settingsData = Home.settings;
    _messagingData = Home.userMessaging;

    if (mounted) {
      setState(() {
        _showWeatherState = _settingsData.showWeather;
        _notificationsNews = _settingsData.notificationsShowNews;
        _notificationsEvent = _settingsData.notificationsShowEvent;
        _notificationsPlay = _settingsData.notificationsShowPlay;
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
    return SilkeborgBeachvolleyScaffold(title: FlutterI18n.translate(context, "settings.settingsMain.title"), body: _main(context));
  }

  _main(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          Card(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ChipHeader(FlutterI18n.translate(context, "settings.settingsMain.string1"),
                      expanded: true,
                      backgroundColor: Color(0xffaaacb5),
                      fontSize: 16.0,
                      roundedCorners: false),
                  _showWeather(context),
                ],
              ),
            ),
          ),
          Card(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ChipHeader(FlutterI18n.translate(context, "settings.settingsMain.string2"),
                      expanded: true,
                      backgroundColor: Color(0xffaaacb5),
                      fontSize: 16.0,
                      roundedCorners: false),
                  _notifications(context),
                ],
              ),
            ),
          ),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ChipHeader(FlutterI18n.translate(context, "settings.settingsMain.string3"),
                    expanded: true,
                    backgroundColor: Color(0xffaaacb5),
                    fontSize: 16.0,
                    roundedCorners: false),
                Container(
                    child: _rankingName(context),
                    padding: EdgeInsets.symmetric(horizontal: 15.0)),
                Container(
                    child: _sex(context),
                    padding: EdgeInsets.symmetric(horizontal: 15.0)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _showWeather(BuildContext context) {
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
      title: Text(FlutterI18n.translate(context, "settings.settingsMain.string4")),
    );
  }

  Widget _notifications(BuildContext context) {
    return Column(
      children: <Widget>[
        SwitchListTile(
          onChanged: (bool state) {
            _settingsData.notificationsShowNews = state;
            _settingsData.save();
            if (state) {
              _messagingData.addSubscription(NotificationCategory.news);
            } else {
              _messagingData.removeSubscription(NotificationCategory.news);
            }

            if (mounted) {
              setState(() {
                _notificationsNews = state;
              });
            }
          },
          value: _notificationsNews,
          title: Text(FlutterI18n.translate(context, "settings.settingsMain.string5")),
        ),
        SwitchListTile(
          onChanged: (bool state) {
            _settingsData.notificationsShowEvent = state;
            _settingsData.save();
            if (state) {
              _messagingData.addSubscription(NotificationCategory.event);
            } else {
              _messagingData.removeSubscription(NotificationCategory.event);
            }

            if (mounted) {
              setState(() {
                _notificationsEvent = state;
              });
            }
          },
          value: _notificationsEvent,
          title: Text(FlutterI18n.translate(context, "settings.settingsMain.string6")),
        ),
        SwitchListTile(
          onChanged: (bool state) {
            _settingsData.notificationsShowPlay = state;
            _settingsData.save();
            if (state) {
              _messagingData.addSubscription(NotificationCategory.play);
            } else {
              _messagingData.removeSubscription(NotificationCategory.play);
            }

            if (mounted) {
              setState(() {
                _notificationsPlay = state;
              });
            }
          },
          value: _notificationsPlay,
          title: Text(FlutterI18n.translate(context, "settings.settingsMain.string7")),
        )
      ],
    );
  }

  Widget _rankingName(BuildContext contxet) {
    return TextField(
      controller: _rankingNameController,
      keyboardType: TextInputType.text,
      inputFormatters: [LengthLimitingTextInputFormatter(50)],
      decoration: InputDecoration(
          errorText: _rankingNameError,
          labelText: FlutterI18n.translate(context, "settings.settingsMain.string8"),
          suffixIcon: Icon(Icons.check_circle, color: _rankingNameColor)),
      onSubmitted: (String value) {
        String error;
        Color color = Colors.green;
        if (value.isEmpty) {
          error = FlutterI18n.translate(context, "settings.settingsMain.string9");
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

  Widget _sex(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(FlutterI18n.translate(context, "settings.settingsMain.string12"), style: TextStyle(fontSize: 16.0)),
            _sexElement(FlutterI18n.translate(context, "settings.settingsMain.string10"), "female"),
            _sexElement(FlutterI18n.translate(context, "settings.settingsMain.string11"), "male")
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
