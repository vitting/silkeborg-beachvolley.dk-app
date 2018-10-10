import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';

class BulletinTitle extends StatelessWidget {
  final String name;
  final String photoUrl;
  final String userId;
  final Function onPressed;
  final bool isDetailMode;
  final bool showImage;

  const BulletinTitle(
      {Key key,
      @required this.name,
      @required this.onPressed,
      @required this.userId,
      this.photoUrl = "",
      this.showImage = false,
      this.isDetailMode = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];

    if (showImage) {
      widgets.add(
        Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child:
            CircleAvatar(backgroundImage: CachedNetworkImageProvider(photoUrl)),
      )
      );
    }
    
    widgets.add(
      Expanded(child: Text(name, overflow: TextOverflow.ellipsis))
    );

    if (!isDetailMode && Home.loggedInUser.uid == userId) {
      widgets.add(
        IconButton(
          icon: Icon(Icons.more_horiz),
          onPressed: onPressed,
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: widgets,
      ),
    );
  }
}
