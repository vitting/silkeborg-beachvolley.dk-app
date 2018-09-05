import "package:flutter/material.dart";
import "package:cached_network_image/cached_network_image.dart";
import 'package:silkeborgbeachvolley/helpers/local_user_info_class.dart';
import 'package:silkeborgbeachvolley/helpers/userauth.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/enrollment_main.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/enrollment_stepper_main.dart';

class SilkeborgBeachvolleyScaffold extends StatefulWidget {
  final String title;
  final Widget body;
  final FloatingActionButton floatingActionButton;
  final BottomNavigationBar bottomNavigationBar;
  final List<Widget> actions;
  final bool showDrawer;
  SilkeborgBeachvolleyScaffold(
      {this.title,
      this.body,
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
    _getUserInfo();
  }

  void _getUserInfo() async {
    LocalUserInfo userInfo = await UserAuth.getLoclUserInfo();

    setState(() {
      _photoUrl = userInfo.photoUrl;
      _email = userInfo.email;
      _name = userInfo.name;
    });
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
                  : CachedNetworkImageProvider(_photoUrl)
            )),
        ListTile(
          leading: Icon(Icons.album),
          title: Text(
            "Indmeldelse"),
          onTap: () {
            Navigator.of(context).popAndPushNamed(EnrollmentStepper.routeName);
          },
        ),
        ListTile(
          leading: Icon(Icons.album),
          title: Text("Ranglisten"),
          onTap: () {
            // Navigator.of(context).popAndPushNamed(Enrollment.routeName);
            Navigator.pushNamedAndRemoveUntil(
                context, Enrollment.routeName, ModalRoute.withName("/"));
          },
        ),
        ListTile(
          leading: Icon(Icons.album),
          title: Text("Livescore"),
          onTap: () {
            // Navigator.of(context).popAndPushNamed(Enrollment.routeName);
            Navigator.pushNamedAndRemoveUntil(
                context, Enrollment.routeName, ModalRoute.withName("/"));
          },
        ),
        ListTile(
          leading: Icon(Icons.album),
          title: Text("Stævnekalender"),
          onTap: () {
            // Navigator.of(context).popAndPushNamed(Enrollment.routeName);
            Navigator.pushNamedAndRemoveUntil(
                context, Enrollment.routeName, ModalRoute.withName("/"));
          },
        ),
        ListTile(
          leading: Icon(Icons.album),
          title: Text("Nyheder fra beachvolley.dk"),
          onTap: () {
            // Navigator.of(context).popAndPushNamed(Enrollment.routeName);
            Navigator.pushNamedAndRemoveUntil(
                context, Enrollment.routeName, ModalRoute.withName("/"));
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.album),
          title: Text("Log ud"),
          onTap: () {
            // Navigator.of(context).popAndPushNamed(Enrollment.routeName);
            Navigator.pushNamedAndRemoveUntil(
                context, Enrollment.routeName, ModalRoute.withName("/"));
          },
        ),
        ListTile(
          leading: Icon(Icons.album),
          title: Text("Indstillinger"),
          onTap: () {
            // Navigator.of(context).popAndPushNamed(Enrollment.routeName);
            Navigator.pushNamedAndRemoveUntil(
                context, Enrollment.routeName, ModalRoute.withName("/"));
          },
        )
      ],
    ));
  }
}
