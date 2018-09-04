import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/bulletin_item_datetime_numberofcomments.dart';

class BulletinGameItem extends StatelessWidget {
  final BulletinItemData bulletinItem;
  final Function onTap;
  final Function onLongPress;
  final int maxLines;
  final TextOverflow overflow;
  final bool showDivider;

  BulletinGameItem(
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
              child: Text("Nogen der vil spille på onsdag kl. 13?",
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
