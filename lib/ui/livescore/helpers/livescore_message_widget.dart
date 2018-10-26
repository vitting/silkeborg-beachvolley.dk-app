import 'dart:async';

import 'package:flutter/material.dart';

class LivescoreMatchMessage extends StatefulWidget {
  final Stream<String> messageStream;
  final ValueChanged<bool> onDoubleTapMessage;

  const LivescoreMatchMessage({Key key, @required this.messageStream, this.onDoubleTapMessage}) : super(key: key);
  @override
  _LivescoreMatchMessageState createState() => _LivescoreMatchMessageState();
}

class _LivescoreMatchMessageState extends State<LivescoreMatchMessage> {
  double _opacity = 0.0;
  String _boardMessage = "";
  @override
  void initState() {
    super.initState();

    widget.messageStream.listen((String message) {
      if (mounted) {
        setState(() {
          if (message.isEmpty) {
            _boardMessage = "";
            _opacity = 0.0;
          } else {
            _boardMessage = message;
            _opacity = 1.0;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 400),
      opacity: _opacity,
      curve: Curves.easeInOut,
      child: InkWell(
        onDoubleTap: () {
          widget.onDoubleTapMessage(true);
        },
        child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.black,
                  border: Border.all(
                      color: Colors.white,
                      style: BorderStyle.solid,
                      width: 1.0)),
              child: Text(_boardMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.yellow, fontSize: 14.0, fontFamily: "Scoreboard")),
            ),
          )
        ],
      ),
      )
    );
  }
}
