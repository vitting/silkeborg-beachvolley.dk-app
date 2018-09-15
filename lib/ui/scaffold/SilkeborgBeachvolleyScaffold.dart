import "package:flutter/material.dart";
import "package:cached_network_image/cached_network_image.dart";
import 'package:silkeborgbeachvolley/ui/enrollment/enrollment_main.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/enrollment_stepper_main.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/ranking_main.dart';

class SilkeborgBeachvolleyScaffold extends StatefulWidget {
  final String title;
  final Widget body;
  final Widget floatingActionButton;
  final BottomNavigationBar bottomNavigationBar;
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
      setState(() {
        _photoUrl = Home.loggedInUser.photoUrl;
        _email = Home.loggedInUser.email;
        _name = Home.loggedInUser.displayName;
      });
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
    return Drawer(
        child: ListView(
      children: <Widget>[
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
            Navigator.of(context).popAndPushNamed(EnrollmentStepper.routeName);
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
          leading: Icon(Icons.album),
          title: Text("Livescore"),
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
                context, Enrollment.routeName, ModalRoute.withName("/"));
          },
        ),
        ListTile(
          leading: Icon(Icons.album),
          title: Text("Stævnekalender"),
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
                context, Enrollment.routeName, ModalRoute.withName("/"));
          },
        ),
        ListTile(
          leading: Icon(Icons.album),
          title: Text("Nyheder fra beachvolley.dk"),
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
                context, Enrollment.routeName, ModalRoute.withName("/"));
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.album),
          title: Text("Log ud"),
          onTap: () {
            Navigator.of(context).pushNamed("/settings");
          },
        ),
        ListTile(
          leading: Icon(Icons.album),
          title: Text("Indstillinger"),
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
                context, Enrollment.routeName, ModalRoute.withName("/"));
          },
        )
      ],
    ));
  }
}
