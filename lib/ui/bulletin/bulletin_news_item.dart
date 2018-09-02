import 'dart:async';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/bulletin_item_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/bulletin_detail_item_main.dart';

class BulletinNewsItem extends StatelessWidget {
  final Map item;
  
  BulletinNewsItem(this.item);

  @override
  Widget build(BuildContext context) {
    BulletinItem _bulletinItem = BulletinItem.fromMap(item);
    return _bulletinItemBody(context, _bulletinItem);
  }

  Widget _bulletinItemBody(BuildContext context, BulletinItem bulletinItem) {
    return ListBody(
      children: <Widget>[
        ListTile(
          title: Text(bulletinItem.authorName),
          subtitle: bulletinItem.body != ""
              ? Text(bulletinItem.body,
                  maxLines: 3, overflow: TextOverflow.ellipsis)
              : null,
          leading: CircleAvatar(
              backgroundImage: NetworkImage(bulletinItem.authorPhotoUrl)),
          onTap: () {
            _navigateTobulletinDetailItem(context, bulletinItem);
          },
        ),
        _bulletinDateTimeNumberOfComments(context, bulletinItem),
        Divider()
      ],
    );
  }

  Widget _bulletinDateTimeNumberOfComments(
      BuildContext context, BulletinItem bulletinItem) {
    return Padding(
        padding: const EdgeInsetsDirectional.only(start: 74.0, top: 2.0),
        child: Row(
          children: <Widget>[
            Icon(Icons.access_time, size: 12.0),
            Padding(
                padding: const EdgeInsetsDirectional.only(start: 5.0),
                child: Text(
                  bulletinItem.creationDateFormatted,
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 12.0),
                )),
            FlatButton(
                onPressed: () {
                  _navigateTobulletinDetailItem(context, bulletinItem);
                },
                child: Row(
                  children: <Widget>[
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
                )),
          ],
        ));
  }

  Future<bool> _navigateTobulletinDetailItem(BuildContext context, BulletinItem bulletinItem) async {
    return await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => BulletinDetailItem(bulletinItem)));
  }
}
