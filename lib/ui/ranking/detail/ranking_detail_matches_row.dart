import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RankingMatchesRow extends StatelessWidget {
  final String winnerId;
  final String loserId;
  final String winnerPhotoUrl;
  final String loserPhotoUrl;
  final String winnerName;
  final String loserName;
  final String userId;

  const RankingMatchesRow({Key key, @required this.winnerPhotoUrl, @required this.loserPhotoUrl, @required this.winnerName, @required this.loserName, @required this.winnerId, @required this.loserId, @required this.userId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _playerItem(winnerName, winnerPhotoUrl, winnerId),
        _playerItem(loserName, loserPhotoUrl, loserId),
      ],
    );
  }

  Widget _playerItem(String name, String photoUrl, String id) {
    return Flexible(
          flex: 2,
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
                  child: _setNameStyle(name, id)
                ),
              )
            ],
          ),
        );
  }

  Widget _setNameStyle(String name, String id) {
    return Text(name, style: TextStyle(
      fontWeight: userId == id ? FontWeight.bold : FontWeight.normal
    ));
  }
}
