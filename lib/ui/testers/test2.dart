import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

class Test2Widget extends StatelessWidget {
    final ValueChanged<int> changed;

  const Test2Widget({Key key, this.changed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
      title: "test2",
      body: Container(
      child: RaisedButton(
        onPressed: () {
          changed(1);
        },
        child: Text("Test2"),
      ),
    ),
    );
  }
}

