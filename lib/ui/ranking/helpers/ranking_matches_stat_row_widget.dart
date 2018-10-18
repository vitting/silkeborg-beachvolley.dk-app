import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_match_player_data_class.dart';

class RankingMatchesStatRow extends StatelessWidget {
  final RankingMatchPlayerData winner;
  final RankingMatchPlayerData loser;
  final String userId;
  final bool showPoints;

  const RankingMatchesStatRow(
      {Key key,
      @required this.winner,
      @required this.loser,
      @required this.userId, this.showPoints = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _playerItem(winner.name, winner.photoUrl, winner.id, winner.points, Colors.blue),
        _playerItem(loser.name, loser.photoUrl, loser.id, loser.points, Colors.blue[700]),
      ],
    );
  }

  Widget _playerItem(String name, String photoUrl, String id, int point, Color color) {
    return Flexible(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 15.0,
              backgroundImage: CachedNetworkImageProvider(photoUrl),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _getName(name, id),
                    showPoints ? Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Tooltip(
                            message: "Point",
                            child: Icon(FontAwesomeIcons.trophy, size: 12.0, color: color),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text(point.toString()),
                          )
                        ],
                      ),
                    ) : Container()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getName(String name, String id) {
    return Text(name,
        style: TextStyle(
            fontWeight: userId == id ? FontWeight.bold : FontWeight.normal));
  }
}
