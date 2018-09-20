import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/eventItem/event_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/item_datetime_numberofcomments.dart';

class BulletinEventItem extends StatelessWidget {
  final BulletinEventItemData bulletinItem;
  final Function onTap;
  final Function onLongPress;
  final int maxLines;
  final TextOverflow overflow;
  
  BulletinEventItem(
      {this.bulletinItem,
      this.onTap,
      this.onLongPress,
      this.maxLines = 3,
      this.overflow = TextOverflow.ellipsis});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      ListTile(
        onLongPress: onLongPress,
        title: Text(bulletinItem.eventTitle),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.calendar_today,
                    size: 16.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(DateTimeHelpers.ddMMyyyy(
                        bulletinItem.eventStartDate)),
                  ),
                  
                  DateTimeHelpers.dateCompare(bulletinItem.eventStartDate, bulletinItem.eventEndDate) ? Container() :
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text("-"),
                      ),
                      Text(DateTimeHelpers.ddMMyyyy(
                          bulletinItem.eventEndDate))
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.alarm,
                    size: 16.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text("Start: ${DateTimeHelpers.hhnn(bulletinItem.eventStartTime)}"),
                  ),
                  Text("Slut: ${DateTimeHelpers.hhnn(bulletinItem.eventEndTime)}")
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.place,
                    size: 16.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(bulletinItem.eventLocation),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(bulletinItem.body,
                  maxLines: maxLines, overflow: overflow),
            ),
            DateTimeNumberOfCommentsAndPlayers(bulletinItem: bulletinItem)
          ],
        ),
        leading: bulletinItem.eventImageLink.isNotEmpty ? Container(
          width: 70.0,
          height: 70.0,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            image: DecorationImage(
              image: CachedNetworkImageProvider(bulletinItem.eventImageLink),
              fit: BoxFit.fill
            )
          )
        ) : Icon(Icons.event),
        onTap: onTap,
      ),
    ];

    return ListBody(children: widgets);
  }
}
