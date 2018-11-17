import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/helpers/circle_profile_image.dart';
import 'package:silkeborgbeachvolley/helpers/dialogs_class.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_theme.dart';
import 'package:silkeborgbeachvolley/helpers/userauth.dart';
import 'package:silkeborgbeachvolley/ui/main_inheretedwidget.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/admin/admin_enrollment_main.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/main/enrollment_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/admin/admin_ranking_main.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_sharedpref.dart';
import 'package:silkeborgbeachvolley/ui/ranking/main/ranking_main.dart';
import 'package:silkeborgbeachvolley/ui/livescore/main/livescore_main.dart';
import 'package:silkeborgbeachvolley/ui/settings/settings_main.dart';
import 'package:silkeborgbeachvolley/ui/tournament_calendar/main/tournament_calendar_main.dart';
import 'package:silkeborgbeachvolley/ui/users/admin/admin_users_main.dart';
import 'package:silkeborgbeachvolley/ui/write_to/admin/admin_write_to_main.dart';
import 'package:silkeborgbeachvolley/ui/write_to/write_to_main.dart';

class SilkeborgBeacvolleyScaffoldDrawer extends StatefulWidget {
  final BuildContext scaffoldContext;

  const SilkeborgBeacvolleyScaffoldDrawer({Key key, @required this.scaffoldContext}) : super(key: key);
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setUserInfo(context);
  }

  void _setUserInfo(BuildContext context) {
    if (MainInherited.of(context).userId != null) {
      if (mounted) {
        setState(() {
          _photoUrl = MainInherited.of(context).loggedInUser.photoUrl;
          _email = MainInherited.of(context).loggedInUser.email;
          _name = MainInherited.of(context).loggedInUser.displayName;
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
          )),
      ListTile(
        leading: Icon(Icons.assignment,
            color: SilkeborgBeachvolleyTheme.drawerIconColor),
        title: Text(
            FlutterI18n.translate(context, "scaffold.drawerWidget.string1")),
        onTap: () {
          Navigator.of(context).popAndPushNamed(Enrollment.routeName);
        },
      ),
      ListTile(
        leading: Icon(FontAwesomeIcons.volleyballBall,
            color: SilkeborgBeachvolleyTheme.drawerIconColor),
        title: Text(
            FlutterI18n.translate(context, "scaffold.drawerWidget.string2")),
        onTap: () {
          Navigator.of(context).popAndPushNamed(Ranking.routeName);
        },
      ),
      ListTile(
          leading: Icon(Icons.live_tv,
              color: SilkeborgBeachvolleyTheme.drawerIconColor),
          title: Text(
              FlutterI18n.translate(context, "scaffold.drawerWidget.string3")),
          onTap: () {
            Navigator.of(context).popAndPushNamed(Livescore.routeName);
          }),
      ListTile(
        leading: Icon(Icons.calendar_today,
            color: SilkeborgBeachvolleyTheme.drawerIconColor),
        title: Text(
            FlutterI18n.translate(context, "scaffold.drawerWidget.string4")),
        onTap: () {
          Navigator.of(context).popAndPushNamed(TournamentCalendar.routeName);
        },
      ),
      ListTile(
        leading:
            Icon(Icons.mail, color: SilkeborgBeachvolleyTheme.drawerIconColor),
        title: Text(
            FlutterI18n.translate(context, "scaffold.drawerWidget.string10")),
        onTap: () {
          Navigator.of(context).popAndPushNamed(WriteTo.routeName);
        },
      ),
      Divider(),
      ListTile(
        leading: Icon(FontAwesomeIcons.signOutAlt,
            color: SilkeborgBeachvolleyTheme.drawerIconColor),
        title: Text(
            FlutterI18n.translate(context, "scaffold.drawerWidget.string5")),
        onTap: () async {
          Navigator.of(context).pop();

          ConfirmDialogAction logoutAction = await Dialogs.confirmLogout(
              widget.scaffoldContext,
              FlutterI18n.translate(widget.scaffoldContext, "scaffold.drawerWidget.string12"));
          if (logoutAction == ConfirmDialogAction.yes) {
            await UserAuth.signOutWithFacebook();
            await RankingSharedPref.removeIsItFirstTime();
          }
        },
      ),
      ListTile(
        leading: Icon(Icons.settings,
            color: SilkeborgBeachvolleyTheme.drawerIconColor),
        title: Text(
            FlutterI18n.translate(context, "scaffold.drawerWidget.string6")),
        onTap: () {
          Navigator.of(context).popAndPushNamed(Settings.routeName);
        },
      )
    ];

    if (MainInherited.of(context).isAdmin1 ||
        MainInherited.of(context).isAdmin2) {
      widgets.add(Divider());
      widgets.add(ListTile(
        leading: Icon(Icons.people,
            color: SilkeborgBeachvolleyTheme.drawerIconColor),
        title: Text(
            FlutterI18n.translate(context, "scaffold.drawerWidget.string7")),
        onTap: () {
          Navigator.of(context).popAndPushNamed(AdminEnrollment.routeName);
        },
      ));

      widgets.add(ListTile(
        leading: Icon(Icons.people,
            color: SilkeborgBeachvolleyTheme.drawerIconColor),
        title: Text(
            FlutterI18n.translate(context, "scaffold.drawerWidget.string8")),
        onTap: () {
          Navigator.of(context).popAndPushNamed(AdminRanking.routeName);
        },
      ));

      if (MainInherited.of(context).isAdmin1) {
        widgets.add(ListTile(
          leading: Icon(Icons.people,
              color: SilkeborgBeachvolleyTheme.drawerIconColor),
          title: Text(
              FlutterI18n.translate(context, "scaffold.drawerWidget.string9")),
          onTap: () {
            Navigator.of(context).popAndPushNamed(AdminUsers.routeName);
          },
        ));
      }

      widgets.add(ListTile(
        leading: Icon(Icons.people,
            color: SilkeborgBeachvolleyTheme.drawerIconColor),
        title: Text(
            FlutterI18n.translate(context, "scaffold.drawerWidget.string11")),
        onTap: () {
          Navigator.of(context).popAndPushNamed(AdminWriteTo.routeName);
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
