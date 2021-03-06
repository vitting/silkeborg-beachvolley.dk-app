import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/main_inheretedwidget.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/main/bulletin_main.dart';
import 'package:silkeborgbeachvolley/ui/login/login_main.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget homeWidget = Container();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      homeWidget = MainInherited.of(context).isLoggedIn ? Bulletin() : Login();
    });
  }

  @override
  Widget build(BuildContext context) {
    return homeWidget;
  }
}
