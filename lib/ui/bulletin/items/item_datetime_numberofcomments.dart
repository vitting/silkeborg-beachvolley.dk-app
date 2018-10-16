import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/item_data_class.dart';

class DateTimeNumberOfCommentsAndCommits extends StatelessWidget {
  final BulletinItemData bulletinItem;
  final int numberOfCommits;
  final Function onTapPlayerCount;
  final double size;
  const DateTimeNumberOfCommentsAndCommits(
      {this.bulletinItem,
      this.numberOfCommits = -1,
      this.onTapPlayerCount,
      this.size = 14.0});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _creationDate(bulletinItem.creationDateFormatted),
          _commentsCounter(bulletinItem.numberOfcomments.toString()),
          _commitsCounter(context)
        ],
      ),
    );
  }

  Widget _creationDate(String date) {
    return Row(
      children: <Widget>[
        Icon(Icons.access_time, size: size),
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Text(
            date,
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: size),
          ),
        )
      ],
    );
  }

  Widget _commentsCounter(String numberOfComments) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.chat_bubble_outline,
          size: size,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Text(
            numberOfComments,
            style: TextStyle(fontSize: size),
          ),
        ),
      ],
    );
  }

  Widget _commitsCounter(BuildContext context) {
    return numberOfCommits == -1
        ? Container()
        : InkWell(
            onTap: onTapPlayerCount,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.people,
                  size: size,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    numberOfCommits.toString(),
                    style: TextStyle(fontSize: size),
                  ),
                )
              ],
            ),
          );
  }
}
