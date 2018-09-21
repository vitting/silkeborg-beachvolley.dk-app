import 'package:flutter/material.dart';

class RankingDetailMatchesHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text("Vindere",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20.0)),
                ),
                Expanded(
                  child: Text("Tabere",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20.0)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
