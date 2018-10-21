import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/circle_profile_image.dart';

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
        CircleProfileImage(
          url: photoUrl
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(name),
        )
      ],
    );
  }
}
