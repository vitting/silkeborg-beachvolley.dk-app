import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_match_data.dart';

class RankingMatchesRow extends StatelessWidget {
  final RankingMatchPlayerData winner;
  final RankingMatchPlayerData loser;
  final String userId;

  const RankingMatchesRow({Key key, @required this.winner, @required this.loser, @required this.userId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _playerItem(winner.name, winner.photoUrl, winner.id),
        _playerItem(loser.name, loser.photoUrl, loser.id),
      ],
    );
  }

  Widget _playerItem(String name, String photoUrl, String id) {
    return Flexible(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 15.0,
                  backgroundImage:
                      CachedNetworkImageProvider(photoUrl),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                    child: _getName(name, id)
                  ),
                )
              ],
            ),
          ),
        );
  }

  Widget _getName(String name, String id) {
    return Text(name, style: TextStyle(
      fontWeight: userId == id ? FontWeight.bold : FontWeight.normal
    ));
  }
}
