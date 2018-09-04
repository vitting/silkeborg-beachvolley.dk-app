import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/local_user_info_class.dart';
import 'package:silkeborgbeachvolley/helpers/userauth.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_event_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_game_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_news_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';
import 'package:uuid/uuid.dart';

class BulletinItemCreator {
  static dynamic createBulletinItem(
      {@required String type,
      @required String body,
      DateTime eventStartDate,
      DateTime eventEndDate,
      TimeOfDay eventStartTime,
      TimeOfDay eventEndTime, String eventLocation}) async {
    Uuid _uuid = new Uuid();
    LocalUserInfo _localuserInfo = await UserAuth.getLoclUserInfo();

    switch (type) {
      case BulletinType.news:
        return BulletinNewsItemData(
            type: type,
            authorId: _localuserInfo.id,
            authorName: _localuserInfo.name,
            authorPhotoUrl: _localuserInfo.photoUrl,
            id: _uuid.v4(),
            body: body,
            creationDate: DateTime.now(),
            numberOfcomments: 0);
        break;
      case BulletinType.event:
        // We are combining date and time 
        DateTime start = DateTime(
        eventStartDate.year,
        eventStartDate.month,
        eventStartDate.day,
        eventStartTime.hour,
        eventStartTime.minute);

        DateTime end = DateTime(
        eventEndDate.year,
        eventEndDate.month,
        eventEndDate.day,
        eventEndTime.hour,
        eventEndTime.minute);
        return BulletinEventItemData(
            type: type,
            authorId: _localuserInfo.id,
            authorName: _localuserInfo.name,
            authorPhotoUrl: _localuserInfo.photoUrl,
            id: _uuid.v4(),
            body: body,
            creationDate: DateTime.now(),
            numberOfcomments: 0,
            eventLocation: eventLocation,
            eventStartDate: start,
            eventEndDate: end,
            eventStartTime: start,
            eventEndTime: end);
        break;
      case BulletinType.play:
        return BulletinGameItemData(
            type: type,
            authorId: _localuserInfo.id,
            authorName: _localuserInfo.name,
            authorPhotoUrl: _localuserInfo.photoUrl,
            id: _uuid.v4(),
            body: body,
            creationDate: DateTime.now(),
            numberOfcomments: 0);
        break;
    }
  }
}
