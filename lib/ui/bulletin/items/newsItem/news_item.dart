import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_image_data.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_item_image_viewer_widget.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_item_pictures_widget.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_title_widget.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/image_type_enum.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/newsItem/news_item_data.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/item_datetime_numberofcomments.dart';

class BulletinNewsItem extends StatelessWidget {
  final BulletinNewsItemData bulletinItem;
  final Function onTap;
  final Function onPressed;
  final int maxLines;
  final TextOverflow overflow;
  final bool isDetailMode;

  const BulletinNewsItem(
      {this.bulletinItem,
      this.onTap,
      this.onPressed,
      this.maxLines = 3,
      this.overflow = TextOverflow.ellipsis,
      this.isDetailMode = false});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      ListTile(
        title: BulletinTitle(
          name: bulletinItem.authorName,
          userId: bulletinItem.authorId,
          photoUrl: bulletinItem.authorPhotoUrl,
          onPressed: onPressed,
          isDetailMode: isDetailMode,
          showImage: true,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(bulletinItem.body,
                  maxLines: maxLines, overflow: overflow),
            ),
            BulletinItemPictures(
              images: bulletinItem.images.map((BulletinImageData data) {
                return data.link;
              }).toList(),
              type: BulletinImageType.network,
              onTapImageSelected: isDetailMode
                  ? (String image) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              BulletinItemImageViewer(image),
                          fullscreenDialog: true));
                    }
                  : null,
            ),
            DateTimeNumberOfCommentsAndCommits(bulletinItem: bulletinItem)
          ],
        ),
        onTap: onTap,
      )
    ];

    return ListBody(children: widgets);
  }
}
