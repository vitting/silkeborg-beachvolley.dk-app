import 'package:flutter/material.dart';
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
      body: Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.4,
          child: ModalBarrier(
            color: Colors.grey,
            dismissible: false,
          ),
        ),
        Center(
          child: Image.asset("assets/images/beachball_fade_64x64.gif"),
        )
      ],
    ),
    );
  }
}