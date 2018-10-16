import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/helpers/confirm_dialog_action_enum.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/dialogs_class.dart';
import 'package:silkeborgbeachvolley/helpers/list_item_card_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'package:silkeborgbeachvolley/ui/tournament_calendar/helpers/torunament_data.dart';
import 'package:silkeborgbeachvolley/ui/tournament_calendar/create/tournament_create_main.dart';

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

  void _loadTournaments() async {
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
      title: "Turneringer",
      body: _main(),
      floatingActionButton: _floatingActionButton(),
    );
  }

  Widget _floatingActionButton() {
    Widget button;
    if (_isAdmin) {
      button = FloatingActionButton(
        backgroundColor: Colors.deepOrange[700],
        onPressed: () async {
          await _showCreateDialog(null, "Opret turnering");
        },
        child: Icon(Icons.add),
      );
    }

    return button;
  }

  Widget _main() {
    if (_tournaments.length == 0) {
      return Card(child: Center(child: Text("Der er pt. ingen turneringer")));
    }
    return Scrollbar(
      child: ListView.builder(
        itemCount: _tournaments.length,
        itemBuilder: (BuildContext context, int position) {
          TournamentData item = _tournaments[position];
          return ListItemCard(
            title: Row(
              children: _tournamentTitle(item),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(item.body))
                ],
              ),
              subtitle: item.link.isEmpty
                  ? null
                  : FlatButton.icon(
                      label: Text("Gå til hjemmeside"),
                      textColor: Colors.deepOrange[700],
                      icon: Icon(Icons.launch),
                      onPressed: () {
                        _launchUrl(item.link);
                      },
                    ),
              trailing: IconButton(
                color: Colors.deepOrange[700],
                icon: Icon(Icons.more_horiz),
                onPressed: () async {
                  await _menuOnPressed(context, item);
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
      _loadTournaments();
    }
  }

  Future<void> _menuOnPressed(BuildContext context, TournamentData item) async {
    if (_isAdmin) {
      int result = await Dialogs.modalBottomSheet(context, [
        DialogsModalBottomSheetItem("Redigere", Icons.edit, 0),
        DialogsModalBottomSheetItem("Slet", Icons.delete, 1)
      ]);

      switch (result) {
        case 0:
          await _showCreateDialog(item, "Redigere turnering");
          break;
        case 1:
          ConfirmDialogAction action = await Dialogs.confirmDelete(
              context, "Er du sikker på du vil slette turneringen?");

          if (action != null && action == ConfirmDialogAction.delete) {
            await item.delete();
            if (mounted) {
              setState(() {
                _tournaments.remove(item);
              });
            }
          }
          break;
      }
    }
  }

  List<Widget> _tournamentTitle(TournamentData item) {
    bool datesIsDiff =
        DateTimeHelpers.dateCompare(item.startDate, item.endDate);
    List<Widget> widgets = [
      Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Icon(
          FontAwesomeIcons.volleyballBall,
          size: 15.0,
          color: Colors.white,
        ),
      ),
      Text(
        datesIsDiff ? item.startDateFormatted : item.startDateFormattedShort,
        style: TextStyle(color: Colors.white),
      ),
    ];

    if (!datesIsDiff) {
      widgets.addAll([
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(
            "-",
            style: TextStyle(color: Colors.white),
          ),
        ),
        Text(
          item.endDateFormatted,
          style: TextStyle(color: Colors.white),
        )
      ]);
    }

    widgets.addAll([
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Text("-", style: TextStyle(color: Colors.white)),
      ),
      Expanded(
        child: Text(item.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(color: Colors.white)),
      )
    ]);

    return widgets;
  }

  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Could not launch url: $url");
    }
  }
}
