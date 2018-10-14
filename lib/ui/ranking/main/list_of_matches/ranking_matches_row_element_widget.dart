import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RankingMatchesRowElement extends StatelessWidget {
  final String name;
  final int points;
  final String photoUrl;
  final Color backgroundColor;

  const RankingMatchesRowElement(
      {Key key,
      @required this.name,
      @required this.points,
      @required this.photoUrl,
      @required this.backgroundColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 25.0),
          margin: EdgeInsets.only(left: 20.0),
          height: 50.0,
          color: backgroundColor,
          child: Row(children: <Widget>[
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(name,
                    style: TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Row(
                    children: <Widget>[
                      Icon(FontAwesomeIcons.trophy,
                          size: 12.0, color: Colors.white),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(points.toString(),
                            style: TextStyle(color: Colors.white)),
                      )
                    ],
                  ),
                )
              ],
            ))
          ]),
        ),
        Positioned(
          top: 5.0,
          child: CircleAvatar(
            radius: 20.0,
            backgroundImage: CachedNetworkImageProvider(photoUrl),
          ),
        ),
      ],
    );
  }
}
