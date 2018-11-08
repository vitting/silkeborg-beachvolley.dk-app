import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/confirm_dialog_action_enum.dart';
import 'package:silkeborgbeachvolley/helpers/dialogs_class.dart';
import 'package:silkeborgbeachvolley/ui/main_inheretedwidget.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_widget.dart';
import 'package:silkeborgbeachvolley/ui/helpers/no_data_widget.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_match_data.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_matches_row_widget.dart';

class AdminRankingMatches extends StatefulWidget {
  @override
  AdminRankingMatchesState createState() {
    return new AdminRankingMatchesState();
  }
}

class AdminRankingMatchesState extends State<AdminRankingMatches> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: RankingMatchData.getMatchesAsStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print(
              "ERROR admin_ranking_matches_main StreamBuilder: ${snapshot.error}");
          return Container();
        }
        if (!snapshot.hasData) return LoaderSpinner();
        if (snapshot.hasData && snapshot.data.documents.length == 0) {
          return NoData(FlutterI18n.translate(
              context, "ranking.adminRankingMatchesMain.string1"));
        }
        List<RankingMatchData> list = snapshot.data.documents
            .map<RankingMatchData>((DocumentSnapshot doc) {
          return RankingMatchData.fromMap(doc.data);
        }).toList();

        return _list(context, list);
      },
    );
  }

  Widget _list(BuildContext context, List<RankingMatchData> list) {
    return Container(
      constraints: BoxConstraints.expand(),
      child: Scrollbar(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (BuildContext context, int position) {
            RankingMatchData item = list[position];
            return RankingMatchesRow(
              match: item,
              userId: MainInherited.of(context).loggedInUser.uid,
              icon: _menuIcon(context, item),
              iconOnTap: (RankingMatchData match) {
                _showDelete(context, match);
              },
            );
          },
        ),
      ),
    );
  }

  IconData _menuIcon(BuildContext context, RankingMatchData match) {
    IconData icon;
    if (MainInherited.of(context).isAdmin1) {
      icon = Icons.more_horiz;
    }
    return icon;
  }

  Future<void> _showDelete(BuildContext context, RankingMatchData match) async {
    int result = await Dialogs.modalBottomSheet(context, [
      DialogsModalBottomSheetItem(
          FlutterI18n.translate(
              context, "ranking.adminRankingMatchesMain.string2"),
          Icons.delete,
          0)
    ]);

    if (result != null) {
      ConfirmDialogAction action = await Dialogs.confirmDelete(
          context,
          FlutterI18n.translate(
              context, "ranking.adminRankingMatchesMain.string3"));

      if (action != null && action == ConfirmDialogAction.delete) {
        match.delete();
      }
    }
  }
}
