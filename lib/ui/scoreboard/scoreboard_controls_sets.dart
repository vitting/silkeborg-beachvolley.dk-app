import 'package:flutter/material.dart';

class ScoreBoardControlsSets extends StatelessWidget {
  final Function addSet;
  final Function removeSet;

  ScoreBoardControlsSets(this.addSet, this.removeSet);

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
                onPressed: () => removeSet(1),
              ),
              Text("sets"),
              IconButton(
                icon: const Icon(Icons.add_circle),
                iconSize: 45.0,
                onPressed: () => addSet(1),
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
                onPressed: () => removeSet(2),
              ),
              Text("sets"),
              IconButton(
                icon: const Icon(Icons.add_circle),
                iconSize: 45.0,
                onPressed: () => addSet(2),
              )
            ],
          ))
        ],
      ),
    );
  }
}