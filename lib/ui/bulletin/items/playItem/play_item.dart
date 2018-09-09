import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/playItem/play_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/item_datetime_numberofcomments.dart';

class BulletinPlayItem extends StatelessWidget {
  final BulletinPlayItemData bulletinItem;
  final Function onTap;
  final Function onLongPress;
  final int maxLines;
  final TextOverflow overflow;
  final int numberOfComments;

  BulletinPlayItem(
      {this.bulletinItem,
      this.onTap,
      this.onLongPress,
      this.maxLines = 3,
      this.overflow = TextOverflow.ellipsis,
      this.numberOfComments = -1});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      ListTile(
        onLongPress: onLongPress,
        title: Text(bulletinItem.authorName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(bulletinItem.body,
                  maxLines: maxLines, overflow: overflow),
            ),
            BulletinItemDateTimeNumberOfComments(bulletinItem: bulletinItem, numberOfComments: numberOfComments)
          ],
        ),
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(bulletinItem.authorPhotoUrl)
        ),
        onTap: onTap,
      )
    ];

    return ListBody(children: widgets);
  }
}
