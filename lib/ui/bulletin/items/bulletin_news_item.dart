import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/bulletin_item_datetime_numberofcomments.dart';
import "package:cached_network_image/cached_network_image.dart";
import 'package:silkeborgbeachvolley/ui/bulletin/items/bulletin_news_item_pictures.dart';

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
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                  backgroundImage:
                      CachedNetworkImageProvider(bulletinItem.authorPhotoUrl)),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(bulletinItem.authorName),
              )
            ],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(bulletinItem.body,
                  maxLines: maxLines, overflow: overflow),
            ),
            BulletinNewsItemPictures(
              images: [
                "assets/images/testpic1.jpg",
                "assets/images/testpic2.jpg",
                "assets/images/testpic3.jpg",
                "assets/images/testpic4.jpg"
              ],
            ),
            BulletinItemDateTimeNumberOfComments(
                bulletinItem: bulletinItem, numberOfComments: numberOfComments)
          ],
        ),
        onTap: onTap,
      )
    ];

    return ListBody(children: widgets);
  }
}
