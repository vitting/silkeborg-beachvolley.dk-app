import "package:flutter/material.dart";
import "package:cached_network_image/cached_network_image.dart";
import 'package:silkeborgbeachvolley/helpers/confirm_action_enum.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/enrollment_main.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/main/ranking_main.dart';
import 'package:silkeborgbeachvolley/ui/settings/settings_main.dart';
import 'package:silkeborgbeachvolley/ui/tournament_calendar/tournament_calendar_main.dart';
import '../login/auth_functions.dart' as authFunctions;

class SilkeborgBeachvolleyScaffold extends StatefulWidget {
  final String title;
  final Widget body;
  final Widget floatingActionButton;
  final Widget bottomNavigationBar;
  final List<Widget> actions;
  final bool showDrawer;
  SilkeborgBeachvolleyScaffold(
      {@required this.title,
      @required this.body,
      this.floatingActionButton,
      this.bottomNavigationBar,
      this.showDrawer = false,
      this.actions = const []});
  @override
  _SilkeborgBeachvolleyScaffoldState createState() =>
      _SilkeborgBeachvolleyScaffoldState();
}

class _SilkeborgBeachvolleyScaffoldState
    extends State<SilkeborgBeachvolleyScaffold> {
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
    return Scaffold(
        appBar: AppBar(
            title: Text(widget.title),
            centerTitle: false,
            actions: widget.actions),
        body: widget.body,
        floatingActionButton: widget.floatingActionButton,
        bottomNavigationBar: widget.bottomNavigationBar,
        drawer: widget.showDrawer ? _drawer(context) : null);
  }

  Widget _drawer(BuildContext context) {
    List<Widget> widgets;
    widgets = [
      UserAccountsDrawerHeader(
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
      ListTile(
        leading: Icon(Icons.album),
        title: Text("Nyheder fra beachvolley.dk"),
        onTap: () {},
      ),
      Divider(),
      ListTile(
        leading: Icon(Icons.album),
        title: Text("Log ud"),
        onTap: () async {
          Navigator.of(context).pop();
          ConfirmAction logoutAction = await authFunctions.logoutConfirm(context);
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
      widgets.add(ListTile(
        leading: Icon(Icons.album),
        title: Text("Admin"),
        onTap: () {
          Navigator.of(context).popAndPushNamed(Settings.routeName);
        },
      ));

      widgets.add(ListTile(
        leading: Icon(Icons.album),
        title: Text("Admin2"),
        onTap: () {
          Navigator.of(context).popAndPushNamed(Settings.routeName);
        },
      ));
    }

    return Drawer(
        child: ListView(
      children: widgets,
    ));
  }
}
