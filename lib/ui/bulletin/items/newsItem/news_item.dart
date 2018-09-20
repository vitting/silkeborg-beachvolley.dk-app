import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/image_type.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/newsItem/news_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/item_datetime_numberofcomments.dart';
import "package:cached_network_image/cached_network_image.dart";
import 'package:silkeborgbeachvolley/ui/bulletin/items/newsItem/news_item_image_viewer.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/newsItem/news_item_pictures.dart';

class BulletinNewsItem extends StatelessWidget {
  final BulletinNewsItemData bulletinItem;
  final Function onTap;
  final Function onLongPress;
  final int maxLines;
  final TextOverflow overflow;
  final bool showImageFullScreen;
  
  BulletinNewsItem(
      {this.bulletinItem,
      this.onTap,
      this.onLongPress,
      this.maxLines = 3,
      this.overflow = TextOverflow.ellipsis, this.showImageFullScreen = false});

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
              images: bulletinItem.imageLinks,
              type: BulletinImageType.network,
              onLongpressImageSelected: showImageFullScreen ? (String image) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => NewsItemImageViewer(image),
                  fullscreenDialog: true
                ));
              } : null,
            ),
            DateTimeNumberOfCommentsAndPlayers(
                bulletinItem: bulletinItem)
          ],
        ),
        onTap: onTap,
      )
    ];

    return ListBody(children: widgets);
  }
}
