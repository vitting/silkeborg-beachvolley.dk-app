import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/livescore/control/helpers/livescore_controls_team_row_item_widget.dart';

class LivescoreControlsRow extends StatelessWidget {
  final ValueChanged<int> onTapAdd;
  final ValueChanged<int> onTapRemove;
  final String text;
  final Color color;

  const LivescoreControlsRow({this.text, this.color, this.onTapAdd, this.onTapRemove});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: LivescoreControlsTeamRowItem(
          team: 1,
          text: text,
          color: color,
          onTapAdd: onTapAdd,
          onTapRemove: onTapRemove,
        )),
        Expanded(
            child: LivescoreControlsTeamRowItem(
          team: 2,
          text: text,
          color: color,
          onTapAdd: onTapAdd,
          onTapRemove: onTapRemove,
        ))
      ],
    );
  }
}