import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/helpers/circle_profile_image.dart';
import 'package:silkeborgbeachvolley/helpers/confirm_action_enum.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_theme.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/admin/admin_enrollment_main.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/main/enrollment_main.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/admin/admin_ranking_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/main/ranking_main.dart';
import 'package:silkeborgbeachvolley/ui/livescore/main/livescore_main.dart';
import 'package:silkeborgbeachvolley/ui/settings/settings_main.dart';
import 'package:silkeborgbeachvolley/ui/tournament_calendar/main/tournament_calendar_main.dart';
import 'package:silkeborgbeachvolley/ui/users/admin/admin_users_main.dart';
import 'package:silkeborgbeachvolley/ui/write_to_sbv/write_to_main.dart';
import '../../login/helpers/auth_functions.dart' as authFunctions;

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
          decoration: SilkeborgBeachvolleyTheme.gradientColorBoxDecoration,
          accountEmail: Text(_email),
          accountName: Text(_name),
          currentAccountPicture: CircleProfileImage(
            url: _photoUrl,
          )
          ),
      ListTile(
        leading: Icon(Icons.assignment, color: SilkeborgBeachvolleyTheme.drawerIconColor),
        title: Text(FlutterI18n.translate(context, "scaffold.drawerWidget.string1")),
        onTap: () {
          Navigator.of(context).popAndPushNamed(Enrollment.routeName);
        },
      ),
      ListTile(
        leading: Icon(FontAwesomeIcons.volleyballBall, color: SilkeborgBeachvolleyTheme.drawerIconColor),
        title: Text(FlutterI18n.translate(context, "scaffold.drawerWidget.string2")),
        onTap: () {
          Navigator.of(context).popAndPushNamed(Ranking.routeName);
        },
      ),
      ListTile(
          leading: Icon(Icons.live_tv, color: SilkeborgBeachvolleyTheme.drawerIconColor), 
          title: Text(FlutterI18n.translate(context, "scaffold.drawerWidget.string3")), 
          onTap: () {
            Navigator.of(context).popAndPushNamed(Livescore.routeName);
          }
        ),
      ListTile(
        leading: Icon(Icons.calendar_today, color: SilkeborgBeachvolleyTheme.drawerIconColor),
        title: Text(FlutterI18n.translate(context, "scaffold.drawerWidget.string4")),
        onTap: () {
          Navigator.of(context).popAndPushNamed(TournamentCalendar.routeName);
        },
      ),
      ListTile(
        leading: Icon(Icons.calendar_today, color: SilkeborgBeachvolleyTheme.drawerIconColor),
        title: Text(FlutterI18n.translate(context, "scaffold.drawerWidget.string10")),
        onTap: () {
          Navigator.of(context).popAndPushNamed(WriteTo.routeName);
        },
      ),
      Divider(),
      ListTile(
        leading: Icon(FontAwesomeIcons.signOutAlt, color: SilkeborgBeachvolleyTheme.drawerIconColor),
        title: Text(FlutterI18n.translate(context, "scaffold.drawerWidget.string5")),
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
        leading: Icon(Icons.settings, color: SilkeborgBeachvolleyTheme.drawerIconColor),
        title: Text(FlutterI18n.translate(context, "scaffold.drawerWidget.string6")),
        onTap: () {
          Navigator.of(context).popAndPushNamed(Settings.routeName);
        },
      )
    ];

    if (Home.userInfo != null && Home.userInfo.admin1) {
      widgets.add(Divider());
      widgets.add(ListTile(
        leading: Icon(Icons.people, color: SilkeborgBeachvolleyTheme.drawerIconColor),
        title: Text(FlutterI18n.translate(context, "scaffold.drawerWidget.string7")),
        onTap: () {
          Navigator.of(context).popAndPushNamed(AdminEnrollment.routeName);
        },
      ));

      widgets.add(ListTile(
        leading: Icon(Icons.people, color: SilkeborgBeachvolleyTheme.drawerIconColor),
        title: Text(FlutterI18n.translate(context, "scaffold.drawerWidget.string8")),
        onTap: () {
          Navigator.of(context).popAndPushNamed(AdminRanking.routeName);
        },
      ));

      widgets.add(ListTile(
        leading: Icon(Icons.people, color: SilkeborgBeachvolleyTheme.drawerIconColor),
        title: Text(FlutterI18n.translate(context, "scaffold.drawerWidget.string9")),
        onTap: () {
          Navigator.of(context).popAndPushNamed(AdminUsers.routeName);
        },
      ));
    }

    return Drawer(
        child: Scrollbar(
                  child: ListView(
      children: widgets,
    ),
        ));
  }
}
