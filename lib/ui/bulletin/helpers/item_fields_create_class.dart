import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_item_data.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/eventItem/event_item_data.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/newsItem/news_item_data.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/playItem/play_item_data.dart';

class ItemFieldsCreate {
  String id;
  dynamic creationDate;
  BulletinType type;
  String body;
  int numberOfcomments;
  int numberOfCommits;
  DateTime eventStartDate;
  DateTime eventEndDate;
  dynamic eventStartTime;
  dynamic eventEndTime;
  String eventLocation;
  String eventTitle;

  ItemFieldsCreate({this.id, this.creationDate, this.type, this.body = "", this.eventEndDate, this.eventEndTime, this.eventLocation  ="", this.eventStartDate, this.eventStartTime, this.eventTitle = "", this.numberOfcomments = 0, this.numberOfCommits = 0});

  factory ItemFieldsCreate.fromBulletinItem(BulletinItemData item) {
    ItemFieldsCreate data;
    if (item.type == BulletinType.news) {
      BulletinNewsItemData news = item as BulletinNewsItemData;
      data = ItemFieldsCreate(
        id: news.id,
        creationDate: news.creationDate,
        numberOfcomments: news.numberOfcomments,
        body: news.body, 
        type: news.type,
      );
    } 

    if (item.type == BulletinType.play) {
      BulletinPlayItemData play = item as BulletinPlayItemData;
      data = ItemFieldsCreate(
        id: play.id,
        creationDate: play.creationDate,
        numberOfcomments: play.numberOfcomments,
        body: play.body, 
        type: play.type,
        numberOfCommits: play.numberOfCommits
      );
    }

    if (item.type == BulletinType.event) {
      BulletinEventItemData event = item as BulletinEventItemData;
      data = ItemFieldsCreate(
        id: event.id,
        creationDate: event.creationDate,
        body: event.body,
        type: event.type,
        numberOfcomments: event.numberOfcomments,
        eventTitle: event.eventTitle,
        eventLocation: event.eventLocation,
        eventStartDate: event.eventStartDate,
        eventEndDate: event.eventEndDate,
        eventStartTime: event.eventStartTime,
        eventEndTime: event.eventEndTime
      );
    }

    return data;
  }
}
