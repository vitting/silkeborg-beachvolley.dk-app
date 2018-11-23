import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_widget.dart';
import 'package:silkeborgbeachvolley/ui/helpers/no_data_widget.dart';
import 'package:silkeborgbeachvolley/ui/livescore/control/livescore_control_main.dart';
import 'package:silkeborgbeachvolley/ui/livescore/helpers/livescore_data.dart';
import 'package:silkeborgbeachvolley/ui/livescore/main/helpers/livescore_match_row.dart';
import 'package:silkeborgbeachvolley/ui/livescore/public_board/livescore_public_board_main.dart';

class LivescoreOverviewResults extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: LivescoreData.getMatchesEndedAsStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return LoaderSpinner();
        if (snapshot.hasData && snapshot.data.documents.length == 0)
          return NoData(FlutterI18n.translate(
              context, "livescore.livescoreOverviewResultsWidget.string1"));

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
                Navigator.of(context).push(MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (BuildContext context) => LivescorePublicBoard(
                          livescoreId: selectedMatch.id,
                        )));
              },
            );
          },
        );
      },
    );
  }
}
