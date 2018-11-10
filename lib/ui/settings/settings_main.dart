import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/ui/main_inheretedwidget.dart';
import 'package:silkeborgbeachvolley/ui/helpers/chip_header_widget.dart';
import 'package:silkeborgbeachvolley/helpers/notification_categories_enum.dart';
import 'package:silkeborgbeachvolley/helpers/user_messaging_data.dart';
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
  bool _notificationsWriteTo = false;
  bool _notificationsWriteToAdmin = false;
  bool _livescorePublicBoardKeepScreenOn = true;
  bool _livescoreControlBoardKeepScreenOn = true;
  TextEditingController _rankingNameController = TextEditingController();
  String _rankingNameError;
  Color _rankingNameColor;
  String _sexValue;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getSettings(context);
  }

  Future<Null> _getSettings(BuildContext context) async {
    _settingsData = MainInherited.of(context).settings;
    _messagingData = MainInherited.of(context).userMessaging;

    if (mounted) {
      setState(() {
        _showWeatherState = _settingsData.showWeather;
        _notificationsNews = _settingsData.notificationsShowNews;
        _notificationsEvent = _settingsData.notificationsShowEvent;
        _notificationsPlay = _settingsData.notificationsShowPlay;
        _notificationsWriteTo = _settingsData.notificationsShowWriteTo;
        _notificationsWriteToAdmin =
            _settingsData.notificationsShowWriteToAdmin;
        if (_settingsData.rankingName.isNotEmpty) {
          _rankingNameController.value =
              TextEditingValue(text: _settingsData.rankingName);
        } else {
          _rankingNameController.value = TextEditingValue(
              text: MainInherited.of(context).loggedInUser.displayName);
        }

        _sexValue = _settingsData.sex;

        _livescorePublicBoardKeepScreenOn =
            _settingsData.livescorePublicBoardKeepScreenOn;
        _livescoreControlBoardKeepScreenOn =
            _settingsData.livescoreControlBoardKeepScreenOn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        title: FlutterI18n.translate(context, "settings.settingsMain.title"),
        body: _main(context));
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
                  ChipHeader(
                      FlutterI18n.translate(
                          context, "settings.settingsMain.string1"),
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
                  ChipHeader(
                      FlutterI18n.translate(
                          context, "settings.settingsMain.string2"),
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
                ChipHeader(
                    FlutterI18n.translate(
                        context, "settings.settingsMain.string3"),
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
          ),
          Card(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ChipHeader(
                      FlutterI18n.translate(
                          context, "settings.settingsMain.string13"),
                      expanded: true,
                      backgroundColor: Color(0xffaaacb5),
                      fontSize: 16.0,
                      roundedCorners: false),
                  _livescore(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showWeather(BuildContext context) {
    return SwitchListTile(
      onChanged: (bool state) async {
        MainInherited.of(context).settings = await _settingsData.setShowWeather(
            MainInherited.of(context).loggedInUser.uid, state);

        setState(() {
          _showWeatherState = state;
        });
      },
      value: _showWeatherState,
      title:
          Text(FlutterI18n.translate(context, "settings.settingsMain.string4")),
    );
  }

  Widget _notifications(BuildContext context) {
    return Column(
      children: <Widget>[
        SwitchListTile(
          onChanged: (bool state) async {
            MainInherited.of(context).settings =
                await _settingsData.setNotificationNews(
                    MainInherited.of(context).loggedInUser.uid, state);

            if (state) {
              _messagingData.addSubscription(NotificationCategory.news);
            } else {
              _messagingData.removeSubscription(NotificationCategory.news);
            }

            setState(() {
              _notificationsNews = state;
            });
          },
          value: _notificationsNews,
          title: Text(
              FlutterI18n.translate(context, "settings.settingsMain.string5")),
        ),
        SwitchListTile(
          onChanged: (bool state) async {
            MainInherited.of(context).settings =
                await _settingsData.setNotificationEvent(
                    MainInherited.of(context).loggedInUser.uid, state);
            if (state) {
              _messagingData.addSubscription(NotificationCategory.event);
            } else {
              _messagingData.removeSubscription(NotificationCategory.event);
            }

            setState(() {
              _notificationsEvent = state;
            });
          },
          value: _notificationsEvent,
          title: Text(
              FlutterI18n.translate(context, "settings.settingsMain.string6")),
        ),
        SwitchListTile(
          onChanged: (bool state) async {
            MainInherited.of(context).settings =
                await _settingsData.setNotificationPlay(
                    MainInherited.of(context).loggedInUser.uid, state);

            if (state) {
              _messagingData.addSubscription(NotificationCategory.play);
            } else {
              _messagingData.removeSubscription(NotificationCategory.play);
            }

            setState(() {
              _notificationsPlay = state;
            });
          },
          value: _notificationsPlay,
          title: Text(
              FlutterI18n.translate(context, "settings.settingsMain.string7")),
        ),
        SwitchListTile(
          onChanged: (bool state) async {
            MainInherited.of(context).settings =
                await _settingsData.setNotificationWriteTo(
                    MainInherited.of(context).loggedInUser.uid, state);

            if (state) {
              _messagingData.addSubscription(NotificationCategory.writeTo);
            } else {
              _messagingData.removeSubscription(NotificationCategory.writeTo);
            }

            setState(() {
              _notificationsWriteTo = state;
            });
          },
          value: _notificationsWriteTo,
          title: Text(
              FlutterI18n.translate(context, "settings.settingsMain.string16")),
        ),
        MainInherited.of(context).isAdmin2
            ? SwitchListTile(
                onChanged: (bool state) async {
                  MainInherited.of(context).settings =
                      await _settingsData.setNotificationWriteToAdmin(
                          MainInherited.of(context).loggedInUser.uid, state);

                  if (state) {
                    _messagingData
                        .addSubscription(NotificationCategory.writeToAdmin);
                  } else {
                    _messagingData
                        .removeSubscription(NotificationCategory.writeToAdmin);
                  }

                  setState(() {
                    _notificationsWriteToAdmin = state;
                  });
                },
                value: _notificationsWriteToAdmin,
                title: Text(FlutterI18n.translate(
                    context, "settings.settingsMain.string17")),
              )
            : Container()
      ],
    );
  }

  Widget _rankingName(BuildContext contxet) {
    return TextField(
      controller: _rankingNameController,
      keyboardType: TextInputType.text,
      // textInputAction: TextInputAction.done,
      inputFormatters: [LengthLimitingTextInputFormatter(50)],
      decoration: InputDecoration(
          errorText: _rankingNameError,
          labelText:
              FlutterI18n.translate(context, "settings.settingsMain.string8"),
          suffixIcon: Icon(Icons.check_circle, color: _rankingNameColor)),
      onSubmitted: (String value) async {
        String error;
        Color color = Colors.green;
        if (value.isEmpty) {
          error =
              FlutterI18n.translate(context, "settings.settingsMain.string9");
          color = Colors.red;
        } else {
          MainInherited.of(context).settings =
              await _settingsData.setRankingName(
                  MainInherited.of(context).loggedInUser.uid, value);
        }

        setState(() {
          _rankingNameColor = color;
          _rankingNameError = error;
        });
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
            Text(
                FlutterI18n.translate(
                    context, "settings.settingsMain.string12"),
                style: TextStyle(fontSize: 16.0)),
            _sexElement(
                context,
                FlutterI18n.translate(
                    context, "settings.settingsMain.string10"),
                "female"),
            _sexElement(
                context,
                FlutterI18n.translate(
                    context, "settings.settingsMain.string11"),
                "male")
          ],
        ),
      ],
    );
  }

  Widget _sexElement(BuildContext context, String text, String radioValue) {
    return Row(
      children: <Widget>[
        Radio(
          groupValue: _sexValue,
          value: radioValue,
          onChanged: (String value) async {
            MainInherited.of(context).settings = await _settingsData.setSex(
                MainInherited.of(context).loggedInUser.uid, value);

            setState(() {
              _sexValue = value;
            });
          },
        ),
        Text(text),
      ],
    );
  }

  Widget _livescore(BuildContext context) {
    return Column(children: <Widget>[
      SwitchListTile(
        onChanged: (bool state) async {
          MainInherited.of(context).settings =
              await _settingsData.setLivescoreBoardKeepScreenOnPublic(
                  MainInherited.of(context).loggedInUser.uid, state);

          setState(() {
            _livescorePublicBoardKeepScreenOn = state;
          });
        },
        value: _livescorePublicBoardKeepScreenOn,
        title: Text(
            FlutterI18n.translate(context, "settings.settingsMain.string14")),
      ),
      SwitchListTile(
        onChanged: (bool state) async {
          MainInherited.of(context).settings =
              await _settingsData.setLivescoreBoardKeepScreenOnControl(
                  MainInherited.of(context).loggedInUser.uid, state);

          setState(() {
            _livescoreControlBoardKeepScreenOn = state;
          });
        },
        value: _livescoreControlBoardKeepScreenOn,
        title: Text(
            FlutterI18n.translate(context, "settings.settingsMain.string15")),
      )
    ]);
  }
}
