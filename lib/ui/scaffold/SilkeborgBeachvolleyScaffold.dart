import "package:flutter/material.dart";

class SilkeborgBeachvolleyScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final FloatingActionButton floatingActionButton;
  final BottomNavigationBar bottomNavigationBar;
  final List<Widget> actions;

  SilkeborgBeachvolleyScaffold(
      {this.title,
      this.body,
      this.floatingActionButton,
      this.bottomNavigationBar,
      this.actions = const []});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
          actions: actions,
        ),
        body: body,
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNavigationBar);
  }
}
