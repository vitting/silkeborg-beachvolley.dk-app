import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:flutter_i18n/flutter_i18n.dart';
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
  final ScrollController _scrollController = ScrollController();
  final _defaultNumberOfItemsToLoad = 50;
  int _numberOfItemsToLoad;
  int _currentLengthOfLoadedItems = 0;

  @override
  void initState() {
    super.initState();
    _numberOfItemsToLoad = _defaultNumberOfItemsToLoad;
    _scrollController.addListener(_handleScrollLoadMore);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: RankingMatchData.getMatchesAsStream(_numberOfItemsToLoad),
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

        _currentLengthOfLoadedItems = snapshot.data.documents.length;
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
          controller: _scrollController,
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (BuildContext context, int position) {
            RankingMatchData item = list[position];
            return RankingMatchesRow(
              match: item,
              userId: MainInherited.of(context).userId,
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
    if (MainInherited.of(context).isAdmin1 || MainInherited.of(context).isAdmin2) {
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

  void _handleScrollLoadMore() {
    if (_scrollController.position.extentAfter == 0) {
      if (_currentLengthOfLoadedItems >= _numberOfItemsToLoad)
        setState(() {
          _numberOfItemsToLoad =
              _numberOfItemsToLoad + _defaultNumberOfItemsToLoad;
        });
    }
  }
}
