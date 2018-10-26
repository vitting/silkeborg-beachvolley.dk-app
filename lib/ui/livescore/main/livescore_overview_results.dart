import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_widget.dart';
import 'package:silkeborgbeachvolley/ui/helpers/no_data_widget.dart';
import 'package:silkeborgbeachvolley/ui/livescore/control/livescore_control_main.dart';
import 'package:silkeborgbeachvolley/ui/livescore/helpers/livescore_data.dart';
import 'package:silkeborgbeachvolley/ui/livescore/main/helpers/livescore_match_row.dart';

class LivescoreOverviewResults extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: LivescoreData.getMatchesEnded(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return LoaderSpinner();
        if (snapshot.hasData && snapshot.data.documents.length == 0)
          return NoData("Der blev ikke fundet nogen afsluttede kampe");

        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (BuildContext context, int position) {
            DocumentSnapshot doc = snapshot.data.documents[position];
            LivescoreData match = LivescoreData.fromMap(doc.data);

            return LivescoreMatchRow(
              match: match,
              isFinished: true,
              onLongPressRow: (LivescoreData selectedMatch) {
                Navigator.of(context).push(MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (BuildContext context) => LivescoreControl(
                          match: selectedMatch,
                        )));
              },
              onTapRow: (LivescoreData selectedMatch) {
                ///CHRISTIAN: Vis modal dialog med info
                ///Nej vi skal ikke vi skal bruge board
              },
            );
          },
        );
      },
    );
  }
}
