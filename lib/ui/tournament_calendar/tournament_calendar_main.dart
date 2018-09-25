import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
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
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    if (Home.userInfo != null && Home.userInfo.admin1) {
      _isAdmin = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
      title: "Turnerings kalender",
      body: _main(),
      floatingActionButton: _floatingActionButton(),
    );
  }

  Widget _floatingActionButton() {
    Widget button;
    if (_isAdmin) {
      button = FloatingActionButton(
        onPressed: () async {
          await _showCreateDialog(null);
        },
        child: Icon(Icons.add),
      );
    }

    return button;
  }

  Widget _main() {
    return Card(
      child: FutureBuilder(
        future: TournamentData.getTournaments(),
        builder: (BuildContext context,
            AsyncSnapshot<List<TournamentData>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) return Container();

          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int position) {
              TournamentData item = snapshot.data[position];
              return Card(
                child: ListTile(
                  onLongPress: () async {
                    await _onLongPress(item);
                  },
                  leading: Image.asset("assets/images/beachball_50x50.png",
                      width: 30.0, height: 30.0),
                  title: Text(item.title),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      children: _getDate(item),
                    ),
                  ),
                  trailing: IconButton(
                    tooltip: "Åben i browser",
                    icon: Icon(FontAwesomeIcons.externalLinkAlt, size: 20.0),
                    onPressed: () {
                       _launchUrl(item.link);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showCreateDialog(TournamentData item) async {
    TournamentData data = await Navigator.of(context).push<TournamentData>(
        MaterialPageRoute(
            fullscreenDialog: true,
            builder: (BuildContext context) => CreateTournamentItem(tournament: item)));

    if (data != null) {
      await data.save();
    }
  }

  Future<void> _onLongPress(TournamentData item) async {
    if (_isAdmin) {
      await _showCreateDialog(item);
    }
  }

  List<Widget> _getDate(TournamentData item) {
    List<Widget> widgets = [
      Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Icon(
          Icons.calendar_today,
          size: 15.0,
        ),
      ),
      Text(item.startDateFormatted)
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
