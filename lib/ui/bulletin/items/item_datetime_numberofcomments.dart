import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/eventItem/event_item_data_class.dart';

class BulletinItemDateTimeNumberOfComments extends StatelessWidget {
  final BulletinItemData bulletinItem;

  final int numberOfComments;
  final int numberOfPlayersCommitted;
  BulletinItemDateTimeNumberOfComments(
      {this.bulletinItem,
      this.numberOfComments = 0,
      this.numberOfPlayersCommitted = -1});

  @override
  Widget build(BuildContext context) {
    print(bulletinItem is BulletinEventItemData);
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
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
              padding: const EdgeInsetsDirectional.only(start: 5.0, end: 20.0),
              child: Text(
                numberOfComments.toString(),
                style: TextStyle(fontSize: 12.0),
              )),
          _showPlayerCount()
        ],
      ),
    );
  }

  Widget _showPlayerCount() {
    return numberOfPlayersCommitted == -1
        ? Container()
        : Row(
            children: <Widget>[
              Icon(
                FontAwesomeIcons.volleyballBall,
                size: 12.0,
              ),
              Padding(
                  padding: const EdgeInsetsDirectional.only(start: 5.0),
                  child: Text(
                    numberOfPlayersCommitted.toString(),
                    style: TextStyle(fontSize: 12.0),
                  ))
            ],
          );
  }
}
