import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

class Test3Widget extends StatelessWidget {
    final ValueChanged<int> changed;
    Test3Widget(this.changed);
  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
      title: "test3",
      body: Container(
      child: RaisedButton(
        onPressed: () {
          changed(2);
        },
        child: Text("Test3"),
      ),
    ),
    );
  }
}

