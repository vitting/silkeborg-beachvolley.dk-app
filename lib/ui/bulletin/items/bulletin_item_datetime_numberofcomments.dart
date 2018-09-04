import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_item_data_class.dart';

class BulletinItemDateTimeNumberOfComments extends StatelessWidget {
  final BulletinItemData bulletinItem;

  BulletinItemDateTimeNumberOfComments(this.bulletinItem);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        children: <Widget>[
          Icon(Icons.access_time, size: 12.0),
          Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 20.0),
              child: Text(
                bulletinItem.creationDateFormatted,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 12.0),
              )),
          Icon(
            Icons.chat_bubble_outline,
            size: 12.0,
          ),
          Padding(
              padding: const EdgeInsetsDirectional.only(start: 5.0),
              child: Text(
                bulletinItem.numberOfcomments.toString(),
                style: TextStyle(fontSize: 12.0),
              ))
        ],
      ),
    );
  }
}
