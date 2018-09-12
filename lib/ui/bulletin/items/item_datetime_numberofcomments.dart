import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/item_data_class.dart';

class DateTimeNumberOfCommentsAndPlayers extends StatelessWidget {
  final BulletinItemData bulletinItem;
  final int numberOfPlayersCommitted;
  final Function onTapPlayerCount;
  DateTimeNumberOfCommentsAndPlayers(
      {this.bulletinItem,
      this.numberOfPlayersCommitted = -1,
      this.onTapPlayerCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.access_time, size: 12.0),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
            bulletinItem.creationDateFormatted,
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 12.0),
          ),
              )
            ],
          ),
          
          Row(
            children: <Widget>[
              Icon(
                Icons.chat_bubble_outline,
                size: 12.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
            bulletinItem.numberOfcomments.toString(),
            style: TextStyle(fontSize: 12.0),
          ),
              ),
            ],
          ),
          
          _showPlayerCount(context)
        ],
      ),
    );
  }

  Widget _showPlayerCount(BuildContext context) {
    return numberOfPlayersCommitted == -1
        ? Container()
        : GestureDetector(
            onTap: onTapPlayerCount,
            child: Row(
              children: <Widget>[
                Icon(
                  FontAwesomeIcons.volleyballBall,
                  size: 12.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                        numberOfPlayersCommitted.toString(),
                        style: TextStyle(fontSize: 12.0),
                      ),
                )
              ],
            ),
          );
  }
}
