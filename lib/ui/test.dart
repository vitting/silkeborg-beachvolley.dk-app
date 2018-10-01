import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/loader_spinner.dart';
import 'package:silkeborgbeachvolley/helpers/loader_spinner_overlay_widget.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

class TestWidget extends StatefulWidget {
  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
      title: "test",
      body: LoaderSpinnerOverlay(
        show: true,
        child: Container(
          child: Column(
            children: <Widget>[
              Text("noget"),
              Text("noget2")
            ],
          ),
        ),
      ),
    );
  }
}