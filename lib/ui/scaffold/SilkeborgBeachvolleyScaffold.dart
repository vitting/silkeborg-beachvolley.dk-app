import "package:flutter/material.dart";

class SilkeborgBeachvolleyScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  SilkeborgBeachvolleyScaffold({this.title, this.body});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true
      ),
      body: body
    );
  }
}