import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/circle_profile_image.dart';
import 'package:silkeborgbeachvolley/ui/main_inheretedwidget.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_data_class.dart';

class ChoosePlayerListRow extends StatefulWidget {
  final bool isPlayerSelected;
  final RankingPlayerData player;
  final ValueChanged<Null> onTap;
  final ValueChanged<bool> onLongPress;
  final bool isFavorite;

  const ChoosePlayerListRow(
      {Key key,
      @required this.player,
      @required this.isPlayerSelected,
      @required this.onTap,
      @required this.onLongPress,
      @required this.isFavorite})
      : super(key: key);

  @override
  ChoosePlayerListRowState createState() {
    return new ChoosePlayerListRowState();
  }
}

class ChoosePlayerListRowState extends State<ChoosePlayerListRow> {
  double _opacity = 0.0;
  double _opacityMin = 0.0;
  double _opacityMax = 0.8;

  @override
  initState() {
    if (widget.isFavorite) {
      _opacity = _opacityMax;
    } else {
      _opacity = _opacityMin;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        widget.onTap(null);
      },
      leading: GestureDetector(
          onLongPress: () {
            if (widget.player.userId !=
                MainInherited.of(context).userId) {
              widget.onLongPress(widget.isFavorite);
            }
          },
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              CircleProfileImage(url: widget.player.photoUrl),
              Positioned(
                  bottom: -6.0,
                  right: -6.0,
                  child: Opacity(
                    opacity: _opacity,
                    child: Icon(Icons.favorite, color: Colors.red),
                  ))
            ],
          )),
      title: Text(widget.player.name),
      trailing: _setTrailingIcon(),
    );
  }

  Widget _setTrailingIcon() {
    if (widget.isPlayerSelected)
      return Icon(Icons.check_circle, color: Colors.greenAccent);
    return null;
  }
}
