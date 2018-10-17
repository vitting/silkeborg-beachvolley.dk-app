import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_data_class.dart';

class RankingItem extends StatefulWidget {
  final RankingPlayerData player;
  final bool showAnimation;
  final Function onTap;
  final int position;

  const RankingItem(
      {@required this.player,
      @required this.onTap,
      @required this.position,
      this.showAnimation = false});
  @override
  RankingItemState createState() {
    return new RankingItemState();
  }
}

class RankingItemState extends State<RankingItem>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  void _initAnimation() {
    if (widget.showAnimation) {
      _controller = AnimationController(
          duration: const Duration(milliseconds: 1000), vsync: this);
      _animation = Tween(begin: 0.0, end: 360.0).animate(_controller)
        ..addListener(() {
          setState(() {});
        });

      _controller.forward();
    }
  }

  @override
  void dispose() {
    if (widget.showAnimation) {
      _controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
          child: Container(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 25.0,
              backgroundImage:
                  CachedNetworkImageProvider(widget.player.photoUrl),
            ),
            Container(
              width: 50.0,
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Text(
                "${widget.position + 1}.",
                textAlign: TextAlign.end,
              ),
            ),
            Expanded(
              child: Text(widget.player.name),
            ),
            _pointsToShow()
          ],
        ),
      )),
    );
  }

  Widget _pointsToShow() {
    if (widget.showAnimation) {
      return Transform(
          transform: Matrix4.rotationY(_animation.value * math.pi / 180),
          origin: Offset(25.0, 25.0),
          child: _points());
    } else {
      return _points();
    }
  }

  Widget _points() {
    return Container(
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: _getColorForPoints()),
      height: 50.0,
      width: 50.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "${widget.player.points.total}",
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }

  Color _getColorForPoints() {
    Color color = Colors.blueAccent;
    if (widget.position == 0) color = Color.fromRGBO(212, 175, 5, 1.0);
    if (widget.position == 1) color = Color.fromRGBO(192, 192, 192, 1.0);
    if (widget.position == 2) color = Color.fromRGBO(205, 127, 50, 1.0);

    return color;
  }
}
