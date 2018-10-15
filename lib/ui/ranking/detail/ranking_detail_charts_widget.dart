import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/ranking/detail/ranking_detail_chart_matches_week_widget.dart';
import 'package:silkeborgbeachvolley/ui/ranking/detail/ranking_detail_chart_points_week_widget.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_match_data.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_data_class.dart';

class RankingDetailCharts extends StatefulWidget {
  final RankingPlayerData player;
  final Future<List<RankingMatchData>> matches;
  final double width;
  final double height;
  const RankingDetailCharts(
      {Key key, this.player, this.matches, this.width, this.height})
      : super(key: key);
  @override
  _RankingDetailChartsState createState() => _RankingDetailChartsState();
}

class _RankingDetailChartsState extends State<RankingDetailCharts> {
  CrossFadeState _state = CrossFadeState.showFirst;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        if (mounted) {
          setState(() {
            _state = _state == CrossFadeState.showFirst ? CrossFadeState.showSecond : CrossFadeState.showFirst;
          });
        }
      },
      child: Column(
        children: <Widget>[
          AnimatedCrossFade(
            crossFadeState: _state,
            duration: Duration(milliseconds: 300),
            firstChild: RankingDetailChartMatchesWeek(
                getMatches: widget.matches,
                width: widget.width - 50.0,
                height: widget.height),
            secondChild: RankingDetailChartPointsWeek(
              getMatches: widget.matches,
              width: widget.width - 50.0,
              height: 200.0,
              playerId: widget.player.userId,
            ),
          ),
        ],
      ),
    );
  }
}
