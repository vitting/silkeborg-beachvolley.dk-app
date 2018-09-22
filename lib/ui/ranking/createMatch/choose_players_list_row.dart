import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ChoosePlayerListRow extends StatefulWidget {
  final bool isPlayerSelected;
  final String playerName;
  final String photoUrl;
  final ValueChanged<Null> onTap;

  const ChoosePlayerListRow(
      {Key key,
      @required this.photoUrl,
      @required this.playerName,
      @required this.isPlayerSelected,
      @required this.onTap})
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
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        widget.onTap(null);
      },
      leading: GestureDetector(
          onLongPress: () {
            setState(() {
              _opacity = _opacity == 0.0 ? _opacityMax : _opacityMin;
            });
          },
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(widget.photoUrl),
              ),
              Positioned(
                  bottom: -6.0,
                  right: -6.0,
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                    opacity: _opacity,
                    child: Icon(Icons.favorite, color: Colors.red),
                  ))
            ],
          )),
      title: Text(widget.playerName),
      trailing: _setTrailingIcon(),
    );
  }

  Widget _setTrailingIcon() {
    if (widget.isPlayerSelected)
      return Icon(Icons.check_circle, color: Colors.greenAccent);
    return null;
  }
}
