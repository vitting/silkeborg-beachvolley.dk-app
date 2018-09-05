import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/bulletin_item_datetime_numberofcomments.dart';
import "package:cached_network_image/cached_network_image.dart";

class BulletinNewsItem extends StatelessWidget {
  final BulletinItemData bulletinItem;
  final Function onTap;
  final Function onLongPress;
  final int maxLines;
  final TextOverflow overflow;
  final bool showDivider;
  final int numberOfComments;
  BulletinNewsItem(
      {this.bulletinItem,
      this.onTap,
      this.onLongPress,
      this.maxLines = 3,
      this.overflow = TextOverflow.ellipsis,
      this.numberOfComments = -1,
      this.showDivider = true});

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
            BulletinItemDateTimeNumberOfComments(
                bulletinItem: bulletinItem, numberOfComments: numberOfComments)
          ],
        ),
        // leading: Container(
        //   width: 40.0,
        //   height: 40.0,
        //   decoration: BoxDecoration(
        //     shape: BoxShape.circle,
        //     image: DecorationImage(
        //       image: CachedNetworkImageProvider(bulletinItem.authorPhotoUrl),
        //     ),
        //   ),
        // ),
        leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(bulletinItem.authorPhotoUrl)),
        onTap: onTap,
      )
    ];

    if (showDivider) {
      widgets.add(Divider());
    }
    return ListBody(children: widgets);
  }
}
