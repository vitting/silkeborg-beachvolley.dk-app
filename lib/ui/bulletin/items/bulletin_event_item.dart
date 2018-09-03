import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/helpers/bulletin_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/bulletin_item_datetime_numberofcomments.dart';

class BulletinEventItem extends StatelessWidget {
  final BulletinItemData bulletinItem;
  final Function onTap;
  final Function onLongPress;
  final int maxLines;
  final TextOverflow overflow;
  final bool showDivider;

  BulletinEventItem({this.bulletinItem, this.onTap, this.onLongPress, this.maxLines, this.overflow, this.showDivider = true});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
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
                    maxLines: maxLines, overflow: overflow),
              ),
              BulletinItemDateTimeNumberOfComments(bulletinItem)
            ],
          ),
          leading: Icon(FontAwesomeIcons.calendarAlt),
          onTap: onTap,
        ),
    ];

    if (showDivider) {
      widgets.add(Divider());
    }

    return ListBody(
      children: widgets
    );
  }
}