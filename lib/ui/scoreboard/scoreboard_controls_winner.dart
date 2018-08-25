import 'package:flutter/material.dart';

class ScoreBoardControlsWinners extends StatelessWidget {
  final Function setWinner;
  final Function matchWinner;

  ScoreBoardControlsWinners(this.setWinner, this.matchWinner);

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
                icon: const Icon(Icons.check_circle),
                iconSize: 45.0,
                onPressed: () => setWinner(1),
              ),
              Text("set | match"),
              IconButton(
                icon: const Icon(Icons.check_circle),
                iconSize: 45.0,
                onPressed: () => matchWinner(1),
              )
            ],
          )),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.check_circle),
                iconSize: 45.0,
                onPressed: () => setWinner(2),
              ),
              Text("set | match"),
              IconButton(
                icon: const Icon(Icons.check_circle),
                iconSize: 45.0,
                onPressed: () => matchWinner(2),
              )
            ],
          ))
        ],
      ),
    );
  }
}