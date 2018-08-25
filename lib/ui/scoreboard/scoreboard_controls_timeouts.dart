import 'package:flutter/material.dart';

class ScoreBoardControlsTimeouts extends StatelessWidget {
  final Function addTimeout;
  final Function removeTimeout;

  ScoreBoardControlsTimeouts(this.addTimeout, this.removeTimeout);

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
                onPressed: () => removeTimeout(1),
              ),
              Text("timeouts"),
              IconButton(
                icon: const Icon(Icons.add_circle),
                iconSize: 45.0,
                onPressed: () => addTimeout(1),
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
                onPressed: () => removeTimeout(2),
              ),
              Text("timeouts"),
              IconButton(
                icon: const Icon(Icons.add_circle),
                iconSize: 45.0,
                onPressed: () => addTimeout(2),
              )
            ],
          ))
        ],
      ),
    );
  }
}