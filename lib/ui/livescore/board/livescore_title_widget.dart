import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_theme.dart';

class LivescoreBoardTitle extends StatelessWidget {
  final String title;
  final Color color;

  const LivescoreBoardTitle(
      {Key key, this.title = "", this.color = Colors.white})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12.0,
                  color: color,
                  fontFamily: SilkeborgBeachvolleyTheme.scoreboardFont)),
        ),
      ],
    );
  }
}
