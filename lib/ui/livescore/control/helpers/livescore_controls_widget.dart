import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/livescore/control/helpers/livescore_controls_team_row_widget.dart';

enum LivescoreControlAction { add, remove }

class LivescoreControls extends StatelessWidget {
  final ValueChanged<int> onTapAddPoints;
  final ValueChanged<int> onTapRemovePoints;
  final ValueChanged<int> onTapAddTimeouts;
  final ValueChanged<int> onTapRemoveTimeouts;

  const LivescoreControls(
      {Key key,
      this.onTapAddPoints,
      this.onTapRemovePoints,
      this.onTapAddTimeouts,
      this.onTapRemoveTimeouts})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        LivescoreControlsRow(
          color: Colors.blue[700],
          text: "points",
          onTapAdd: onTapAddPoints,
          onTapRemove: onTapRemovePoints,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: LivescoreControlsRow(
            color: Colors.blue[700],
            text: "timeouts",
            onTapAdd: onTapAddTimeouts,
            onTapRemove: onTapRemoveTimeouts,
          ),
        )
      ],
    );
  }
}
