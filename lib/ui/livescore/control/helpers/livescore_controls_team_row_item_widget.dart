import 'package:flutter/material.dart';

class LivescoreControlsTeamRowItem extends StatelessWidget {
  final ValueChanged<int> onTapAdd;
  final ValueChanged<int> onTapRemove;
  final int team;
  final String text;
  final Color color;

  const LivescoreControlsTeamRowItem({Key key, this.onTapAdd, this.onTapRemove, this.team, this.text, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.do_not_disturb_on, color: color),
              iconSize: 45.0,
              onPressed: () {
                onTapRemove(team);
              },
            ),
            Text(text, style: TextStyle(fontSize: 12.0, color: color)),
            IconButton(
              icon: Icon(Icons.add_circle, color: color),
              iconSize: 45.0,
              onPressed: () {
                onTapAdd(team);
              },
            )
          ],
        );
  }
}