import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

class Test1Widget extends StatelessWidget {
  final ValueChanged<int> changed;
  Test1Widget(this.changed);

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
      title: "test1",
      body: Container(
      child: RaisedButton(
        onPressed: () {
          changed(0);
        },
        child: Text("Test1"),
      ),
    ),
    );
  }
}

