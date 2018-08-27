import "package:flutter/material.dart";

class SilkeborgBeachvolleyScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget floatingActionButton;
  SilkeborgBeachvolleyScaffold({this.title, this.body, this.floatingActionButton});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true
      ),
      body: body,
      floatingActionButton: floatingActionButton
    );
  }
}