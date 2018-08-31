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

  // List<Widget> _actions(BuildContext context) {
  //   return <Widget>[
  //     PopupMenuButton<int>(
  //       initialValue: 1,
  //       onSelected: (value) {
  //         _actionsSelected(context, value);
  //       },
  //       itemBuilder: (BuildContext context) {
  //         return [
  //           PopupMenuItem(
  //             child: Text("Indstillinger"),
  //             value: 1,
  //           )
  //         ];
  //       },
  //       icon: Icon(Icons.more_vert),
  //     )
  //   ];
  // }

  // void _actionsSelected(BuildContext context, int value) async {
  //   if (value == 1) {
  //     var result = await Navigator.pushNamed(context, "/settings");

  //     if (result) {
        
  //     }


  //   }
  // }
}
