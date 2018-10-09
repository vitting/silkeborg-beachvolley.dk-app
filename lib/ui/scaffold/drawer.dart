import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/confirm_action_enum.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/admin/admin_enrollment_main.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/enrollment_main.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/main/ranking_main.dart';
import 'package:silkeborgbeachvolley/ui/settings/settings_main.dart';
import 'package:silkeborgbeachvolley/ui/tournament_calendar/tournament_calendar_main.dart';
import '../login/auth_functions.dart' as authFunctions;

class SilkeborgBeacvolleyScaffoldDrawer extends StatefulWidget {
  @override
  SilkeborgBeacvolleyScaffoldDrawerState createState() {
    return new SilkeborgBeacvolleyScaffoldDrawerState();
  }
}

class SilkeborgBeacvolleyScaffoldDrawerState
    extends State<SilkeborgBeacvolleyScaffoldDrawer> {
  String _photoUrl;
  String _email = "";
  String _name = "";

  @override
  void initState() {
    super.initState();
    _setUserInfo();
  }

  void _setUserInfo() {
    if (Home.loggedInUser != null) {
      if (mounted) {
        setState(() {
          _photoUrl = Home.loggedInUser.photoUrl;
          _email = Home.loggedInUser.email;
          _name = Home.loggedInUser.displayName;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets;
    widgets = [
      UserAccountsDrawerHeader(
        decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.1, 0.5, 0.7, 0.9],
        colors: [
          Colors.blue[300],
          Colors.blue[500],
          Colors.blue[700],
          Colors.blue[900],
        ],
      )),
          accountEmail: Text(_email),
          accountName: Text(_name),
          currentAccountPicture: CircleAvatar(
              backgroundImage: _photoUrl == null
                  ? null
                  : CachedNetworkImageProvider(_photoUrl))),
      ListTile(
        leading: Icon(Icons.album),
        title: Text("Indmeldelse"),
        onTap: () {
          Navigator.of(context).popAndPushNamed(Enrollment.routeName);
        },
      ),
      ListTile(
        leading: Icon(Icons.album),
        title: Text("Ranglisten"),
        onTap: () {
          Navigator.of(context).popAndPushNamed(Ranking.routeName);
        },
      ),
      ListTile(
          leading: Icon(Icons.album), title: Text("Livescore"), onTap: () {}),
      ListTile(
        leading: Icon(Icons.album),
        title: Text("Stævnekalender"),
        onTap: () {
          Navigator.of(context).popAndPushNamed(TournamentCalendar.routeName);
        },
      ),
      Divider(),
      ListTile(
        leading: Icon(Icons.album),
        title: Text("Log af"),
        onTap: () async {
          Navigator.of(context).pop();
          ConfirmAction logoutAction =
              await authFunctions.logoutConfirm(context);
          if (logoutAction == ConfirmAction.yes) {
            await authFunctions.logout();
          }
        },
      ),
      ListTile(
        leading: Icon(Icons.album),
        title: Text("Indstillinger"),
        onTap: () {
          Navigator.of(context).popAndPushNamed(Settings.routeName);
        },
      )
    ];

    if (Home.userInfo != null && Home.userInfo.admin1) {
      widgets.add(Divider());
      widgets.add(ListTile(
        leading: Icon(Icons.album),
        title: Text("Administrere medlemmer"),
        onTap: () {
          Navigator.of(context).popAndPushNamed(AdminEnrollment.routeName);
        },
      ));
    }

    return Drawer(
        child: ListView(
      children: widgets,
    ));
  }
}
