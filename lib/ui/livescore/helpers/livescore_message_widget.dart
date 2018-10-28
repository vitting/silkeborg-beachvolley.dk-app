import 'dart:async';

import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_theme.dart';

class LivescoreMatchMessage extends StatefulWidget {
  final Stream<String> messageStream;
  final String message;
  final ValueChanged<bool> onDoubleTapMessage;

  const LivescoreMatchMessage(
      {Key key,
      @required this.messageStream,
      this.onDoubleTapMessage,
      this.message = ""})
      : super(key: key);
  @override
  _LivescoreMatchMessageState createState() => _LivescoreMatchMessageState();
}

class _LivescoreMatchMessageState extends State<LivescoreMatchMessage> {
  double _opacity = 0.0;
  String _boardMessage = "";

  @override
  void initState() {
    super.initState();
    if (widget.messageStream != null) {
      widget.messageStream.listen((String message) {
        _setMessage(message);
      });
    }
  }

  void _setMessage(String message) {
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
  }

  @override
  Widget build(BuildContext context) {
    if (widget.messageStream == null) {
      _setMessage(widget.message);
    }

    return AnimatedOpacity(
        duration: Duration(milliseconds: 400),
        opacity: _opacity,
        curve: Curves.easeInOut,
        child: InkWell(
          onDoubleTap: () {
            if (widget.onDoubleTapMessage != null)
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
                      color: Colors.black26,
                      border: Border.all(
                          color: Colors.white54,
                          style: BorderStyle.solid,
                          width: 1.5)),
                  child: Text(_boardMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontFamily: SilkeborgBeachvolleyTheme.scoreboardFont)),
                ),
              )
            ],
          ),
        ));
  }
}
