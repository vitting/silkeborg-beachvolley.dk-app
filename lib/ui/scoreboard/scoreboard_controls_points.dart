import 'package:flutter/material.dart';

class ScoreBoardControlsPoints extends StatelessWidget {
  final Function addPoint;
  final Function removePoint;

  ScoreBoardControlsPoints(this.addPoint, this.removePoint);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.do_not_disturb_on),
                iconSize: 45.0,
                onPressed: () => removePoint(1),
              ),
              Text("points"),
              IconButton(
                icon: const Icon(Icons.add_circle),
                iconSize: 45.0,
                onPressed: () => addPoint(1),
              )
            ],
          )),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.do_not_disturb_on),
                iconSize: 45.0,
                onPressed: () => removePoint(2),
              ),
              Text("points"),
              IconButton(
                icon: const Icon(Icons.add_circle),
                iconSize: 45.0,
                onPressed: () => addPoint(2),
              )
            ],
          ))
        ],
      ),
    );
  }
}