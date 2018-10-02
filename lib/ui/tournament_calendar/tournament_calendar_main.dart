import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/list_item_card_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'package:silkeborgbeachvolley/ui/tournament_calendar/helpers/torunament_data_class.dart';
import 'package:silkeborgbeachvolley/ui/tournament_calendar/tournament_create_main.dart';

class TournamentCalendar extends StatefulWidget {
  static final String routeName = "/tournamentcalendar";
  @override
  _TournamentCalendarState createState() => _TournamentCalendarState();
}

class _TournamentCalendarState extends State<TournamentCalendar> {
  List<TournamentData> _tournaments = [];
  bool _isAdmin = false;
  @override
  void initState() {
    _loadTournaments();
    if (Home.userInfo != null && Home.userInfo.admin1) {
      _isAdmin = true;
    }
    super.initState();
  }

  _loadTournaments() async {
    List<TournamentData> data = await TournamentData.getTournaments();
    if (mounted) {
      setState(() {
        _tournaments = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
      title: "Turnerings kalender",
      body: _listView(),
      floatingActionButton: _floatingActionButton(),
    );
  }

  Widget _floatingActionButton() {
    Widget button;
    if (_isAdmin) {
      button = FloatingActionButton(
        onPressed: () async {
          await _showCreateDialog(null, "Opret turnering");
        },
        child: Icon(Icons.add),
      );
    }

    return button;
  }

  Widget _listView() {
    return Scrollbar(
      child: ListView.builder(
        itemCount: _tournaments.length,
        itemBuilder: (BuildContext context, int position) {
          TournamentData item = _tournaments[position];
          return ListItemCard(
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
              onLongPress: () async {
                await _onLongPress(item);
              },
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Container(
                      padding: EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          color: Colors.blue),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _getDate(item),
                      ),
                    ),
                  ),
                  Text(item.title),
                ],
              ),
              trailing: IconButton(
                tooltip: "Åben i browser",
                icon: Icon(FontAwesomeIcons.externalLinkAlt,
                    size: 20.0, color: Colors.blue),
                onPressed: () {
                  _launchUrl(item.link);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showCreateDialog(TournamentData item, String title) async {
    TournamentData data = await Navigator.of(context).push<TournamentData>(
        MaterialPageRoute(
            fullscreenDialog: true,
            builder: (BuildContext context) =>
                CreateTournamentItem(tournament: item, title: title)));

    if (data != null) {
      await data.save();
    }
  }

  Future<void> _onLongPress(TournamentData item) async {
    if (_isAdmin) {
      await _showCreateDialog(item, "Redigere turnering");
    }
  }

  List<Widget> _getDate(TournamentData item) {
    List<Widget> widgets = [
      Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Icon(
          Icons.calendar_today,
          size: 15.0,
          color: Colors.white,
        ),
      ),
      Text(
        item.startDateFormatted,
        style: TextStyle(color: Colors.white),
      )
    ];

    if (!DateTimeHelpers.dateCompare(item.startDate, item.endDate)) {
      widgets.addAll([
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text("-"),
        ),
        Text(item.endDateFormatted)
      ]);
    }

    return widgets;
  }

  void _launchUrl(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Could not launch url: $url");
    }
  }
}
