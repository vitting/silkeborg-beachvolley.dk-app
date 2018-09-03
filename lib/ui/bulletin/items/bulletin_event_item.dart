import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/helpers/bulletin_item_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/bulletin_item_datetime_numberofcomments.dart';

class BulletinEventItem extends StatelessWidget {
  final BulletinItem bulletinItem;
  final Function onTap;
  final Function onLongPress;

  BulletinEventItem({this.bulletinItem, this.onTap, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return ListBody(
      children: <Widget>[
        ListTile(
          onLongPress: onLongPress,
          title: Text("Vi griller på onsdag"),
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
                      child: Text("12. oktober 2018"),
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
                      child: Text("Start: 14:00"),
                    ),
                    Text("Slut: 16:00")
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
                      child: Text("Nylandsvej 22, 8600 Silkeborg"),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text("Tag dit kød med over på banerene på onsdag",
                    maxLines: 3, overflow: TextOverflow.ellipsis),
              ),
              BulletinItemDateTimeNumberOfComments(bulletinItem)
            ],
          ),
          leading: Icon(FontAwesomeIcons.calendarAlt),
          onTap: onTap,
        ),
        Divider()
      ],
    );
  }
}