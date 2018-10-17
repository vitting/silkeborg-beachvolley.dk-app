import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RankingDetailStatTitle extends StatelessWidget {
  final String photoUrl;
  final String name;
  const RankingDetailStatTitle(
      {Key key, @required this.photoUrl, @required this.name})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(photoUrl),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(name),
        )
      ],
    );
  }
}
