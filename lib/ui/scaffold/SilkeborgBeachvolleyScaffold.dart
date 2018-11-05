import "package:flutter/material.dart";
import 'package:silkeborgbeachvolley/ui/scaffold/helpers/drawer_widget.dart';

class SilkeborgBeachvolleyScaffold extends StatefulWidget {
  final String title;
  final Widget body;
  final Widget floatingActionButton;
  final Widget bottomNavigationBar;
  final List<Widget> actions;
  final bool showDrawer;
  final bool showAppBar;
  final Color appBarBackgroundColor;
  const SilkeborgBeachvolleyScaffold(
      {this.title,
      @required this.body,
      this.floatingActionButton,
      this.bottomNavigationBar,
      this.showDrawer = false,
      this.appBarBackgroundColor,
      this.actions = const [],
      this.showAppBar = true});
  @override
  _SilkeborgBeachvolleyScaffoldState createState() =>
      _SilkeborgBeachvolleyScaffoldState();
}

class _SilkeborgBeachvolleyScaffoldState
    extends State<SilkeborgBeachvolleyScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.showAppBar
            ? AppBar(
                backgroundColor: widget.appBarBackgroundColor,
                title: Text(widget.title),
                centerTitle: false,
                actions: widget.actions)
            : null,
        body: widget.body,
        floatingActionButton: widget.floatingActionButton,
        bottomNavigationBar: widget.bottomNavigationBar,
        drawer: widget.showDrawer ? SilkeborgBeacvolleyScaffoldDrawer() : null);
  }
}
