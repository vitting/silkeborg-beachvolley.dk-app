import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/image_type.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/newsItem/news_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/item_datetime_numberofcomments.dart';
import "package:cached_network_image/cached_network_image.dart";
import 'package:silkeborgbeachvolley/ui/bulletin/items/newsItem/news_item_pictures.dart';

class BulletinNewsItem extends StatelessWidget {
  final BulletinNewsItemData bulletinItem;
  final Function onTap;
  final Function onLongPress;
  final int maxLines;
  final TextOverflow overflow;
  final int numberOfComments;
  BulletinNewsItem(
      {this.bulletinItem,
      this.onTap,
      this.onLongPress,
      this.maxLines = 3,
      this.overflow = TextOverflow.ellipsis,
      this.numberOfComments = 0});

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
              images: bulletinItem.images,
              type: BulletinImageType.network,
            ),
            DateTimeNumberOfCommentsAndPlayers(
                bulletinItem: bulletinItem, numberOfComments: numberOfComments)
          ],
        ),
        onTap: onTap,
      )
    ];

    return ListBody(children: widgets);
  }
}
