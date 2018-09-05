import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_formatters.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_event_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/bulletin_item_datetime_numberofcomments.dart';

class BulletinEventItem extends StatelessWidget {
  final BulletinEventItemData bulletinItem;
  final Function onTap;
  final Function onLongPress;
  final int maxLines;
  final TextOverflow overflow;
  final bool showDivider;
  final int numberOfComments;
  
  BulletinEventItem(
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
                    child: Text(DateTimeFormatters.ddMMyyyy(
                        bulletinItem.eventStartDate)),
                  ),
                  
                  DateTimeFormatters.dateCompare(bulletinItem.eventStartDate, bulletinItem.eventEndDate) ? Container() :
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text("-"),
                      ),
                      Text(DateTimeFormatters.ddMMyyyy(
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
                    child: Text("Start: ${DateTimeFormatters.hhnn(bulletinItem.eventStartTime)}"),
                  ),
                  Text("Slut: ${DateTimeFormatters.hhnn(bulletinItem.eventEndTime)}")
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
            BulletinItemDateTimeNumberOfComments(bulletinItem: bulletinItem, numberOfComments: numberOfComments)
          ],
        ),
        leading: Icon(FontAwesomeIcons.calendarAlt),
        onTap: onTap,
      ),
    ];

    if (showDivider) {
      widgets.add(Divider());
    }

    return ListBody(children: widgets);
  }
}
