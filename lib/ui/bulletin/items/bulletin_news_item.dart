import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/bulletin_item_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/bulletin_item_datetime_numberofcomments.dart';

class BulletinNewsItem extends StatelessWidget {
  final BulletinItem bulletinItem;
  final Function onTap;
  final Function onLongPress;

  BulletinNewsItem({this.bulletinItem, this.onTap, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return ListBody(
      children: <Widget>[
        ListTile(
          onLongPress: onLongPress,
          title: Text(bulletinItem.authorName),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(bulletinItem.body, maxLines: 3, overflow: TextOverflow.ellipsis),
              ),
              BulletinItemDateTimeNumberOfComments(bulletinItem)
            ],
          ),
          leading: CircleAvatar(
              backgroundImage: NetworkImage(bulletinItem.authorPhotoUrl)),
          onTap: onTap,
        ),
        Divider()
      ],
    );
  }
}