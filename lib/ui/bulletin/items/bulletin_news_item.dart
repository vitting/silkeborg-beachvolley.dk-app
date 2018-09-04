import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/bulletin_item_datetime_numberofcomments.dart';

class BulletinNewsItem extends StatelessWidget {
  final BulletinItemData bulletinItem;
  final Function onTap;
  final Function onLongPress;
  final int maxLines;
  final TextOverflow overflow;
  final showDivider;

  BulletinNewsItem(
      {this.bulletinItem,
      this.onTap,
      this.onLongPress,
      this.maxLines,
      this.overflow,
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
            BulletinItemDateTimeNumberOfComments(bulletinItem)
          ],
        ),
        leading: CircleAvatar(
            backgroundImage: NetworkImage(bulletinItem.authorPhotoUrl)),
        onTap: onTap,
      )
    ];

    if (showDivider) {
      widgets.add(Divider());
    }
    return ListBody(children: widgets);
  }
}
