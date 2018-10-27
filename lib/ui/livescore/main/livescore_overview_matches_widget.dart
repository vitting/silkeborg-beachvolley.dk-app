import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/confirm_dialog_action_enum.dart';
import 'package:silkeborgbeachvolley/helpers/dialogs_class.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_colors.dart';
import 'package:silkeborgbeachvolley/ui/helpers/chip_header_widget.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_widget.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/livescore/control/livescore_control_main.dart';
import 'package:silkeborgbeachvolley/ui/livescore/helpers/livescore_data.dart';
import 'package:silkeborgbeachvolley/ui/livescore/main/helpers/livescore_match_row.dart';
import 'package:silkeborgbeachvolley/ui/livescore/public_board/livescore_public_board_main.dart';

class LivescoreOverviewMatches extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[_activeMatches(), _upcomingMatches()],
    );
  }

  Widget _activeMatches() {
    return StreamBuilder(
      stream: LivescoreData.getMatchesStarted(),
      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotStarted) {
        if (!snapshotStarted.hasData) return LoaderSpinner();
        if (snapshotStarted.hasData &&
            snapshotStarted.data.documents.length == 0) return Container();
        return Column(
          children: <Widget>[
            ChipHeader("Aktive kampe",
                expanded: true,
                roundedCorners: false,
                textAlign: TextAlign.center,
                backgroundColor: SilkeborgBeachvolleyColors.headerBackground,
                fontSize: 16.0),
            ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: snapshotStarted.data.documents.length,
              itemBuilder: (BuildContext context, int position) {
                DocumentSnapshot doc = snapshotStarted.data.documents[position];
                LivescoreData match = LivescoreData.fromMap(doc.data);
                return LivescoreMatchRow(
                  match: match,
                  isLive: true,
                  onLongPressRow: (LivescoreData selectedMatch) {
                    _onLongPressRow(context, selectedMatch);
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
            ),
          ],
        );
      },
    );
  }

  Widget _upcomingMatches() {
    return StreamBuilder(
      stream: LivescoreData.getMatchesUpcoming(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshotUpcoming) {
        if (!snapshotUpcoming.hasData) return LoaderSpinner();
        if (snapshotUpcoming.hasData &&
            snapshotUpcoming.data.documents.length == 0) return Container();

        return Column(
          children: <Widget>[
            ChipHeader("Kommende kampe",
                expanded: true,
                roundedCorners: false,
                textAlign: TextAlign.center,
                backgroundColor: SilkeborgBeachvolleyColors.headerBackground,
                fontSize: 16.0),
            ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: snapshotUpcoming.data.documents.length,
              itemBuilder: (BuildContext context, int position) {
                DocumentSnapshot doc =
                    snapshotUpcoming.data.documents[position];
                LivescoreData match = LivescoreData.fromMap(doc.data);
                return LivescoreMatchRow(
                  match: match,
                  isLive: false,
                  onLongPressRow: (LivescoreData selectedMatch) {
                    _onLongPressRow(context, selectedMatch);
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
            ),
          ],
        );
      },
    );
  }

  void _onLongPressRow(BuildContext context, LivescoreData match) async {
    if (Home.loggedInUser != null) {
      ConfirmDialogAction action  = await Dialogs.confirmYesNo(context, "Vil du kontrollere kampen?");
      if (action != null && action == ConfirmDialogAction.yes) {
        Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (BuildContext context) => LivescoreControl(
              match: match,
            )));
      }
    }
  }
}
