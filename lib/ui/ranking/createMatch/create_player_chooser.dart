import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_data_class.dart';

enum PlayerChooserType { winner1, winner2, loser1, loser2, winner, loser, none }

class CreatePlayerChooser extends StatelessWidget {
  final ValueChanged<PlayerChooserType> onTapPlayer;
  final RankingPlayerData playerItem;
  final Color color;
  final PlayerChooserType type;

  const CreatePlayerChooser(
      {Key key,
      this.onTapPlayer,
      this.playerItem,
      this.color,
      this.type = PlayerChooserType.none})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapPlayer(type);
      },
      child: CircleAvatar(
        radius: 40.0,
        backgroundImage: playerItem == null
            ? null
            : CachedNetworkImageProvider(playerItem.photoUrl),
        backgroundColor: color,
        child: Icon(Icons.add),
      ),
    );
  }
}
