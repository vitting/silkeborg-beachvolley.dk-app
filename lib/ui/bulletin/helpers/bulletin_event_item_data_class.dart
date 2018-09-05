import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';

class BulletinEventItemData extends BulletinItemData {
  DateTime eventStartDate;
  DateTime eventEndDate;
  DateTime eventStartTime;
  DateTime eventEndTime;
  String eventLocation;
  String eventTitle;
  
    BulletinEventItemData(
        {String id = "",
        String type = BulletinType.none,
        String body = "",
        DateTime creationDate,
        String authorId = "",
        String authorName = "",
        String authorPhotoUrl = "",
        int numberOfcomments = 0,
        this.eventStartDate,
        this.eventEndDate,
        this.eventEndTime,
        this.eventStartTime, this.eventLocation, this.eventTitle})
        : super(
              id: id,
              type: type,
              body: body,
              creationDate: creationDate,
              authorId: authorId,
              authorName: authorName,
              authorPhotoUrl: authorPhotoUrl,
              numberOfcomments: numberOfcomments);
  
    @override
    Map<String, dynamic> toMap() {
      Map<String, dynamic> map = super.toMap();
      map.addAll({
        "event": {"startDate": eventStartDate, "endDate": eventEndDate, "startTime": eventStartTime, "endTime": eventEndTime, "location": eventLocation, "title": eventTitle}
      });
  
      return map;
    }
  
    String get evnetStartDateFormatted =>
        DateTimeHelpers.ddmmyyyy(eventStartDate);  
  
    String get eventEndDateFormatted =>
    DateTimeHelpers.ddmmyyyy(eventStartDate);  
  
    static BulletinEventItemData fromMap(Map<String, dynamic> item) {
      return new BulletinEventItemData(
          id: item["id"] == null ? "" : item["id"],
          type: item["type"] == null ? "" : item["type"],
          authorId: item["author"]["id"] == null ? "" : item["author"]["id"],
          authorName:
              item["author"]["name"] == null ? "" : item["author"]["name"],
          authorPhotoUrl: item["author"]["photoUrl"] == null
              ? ""
              : item["author"]["photoUrl"],
          body: item["body"] == null ? "" : item["body"],
          creationDate: item["creationDate"] == null ? DateTime.now() : item["creationDate"],
          numberOfcomments:
              item["numberOfcomments"] == null ? 0 : item["numberOfcomments"],
          eventStartDate: item["event"]["startDate"] == null ? DateTime.now() : item["event"]["startDate"],
          eventEndDate: item["event"]["endDate"] == null ? DateTime.now() : item["event"]["endDate"],
          eventStartTime: item["event"]["startTime"] == null ? DateTime.now() : item["event"]["startTime"],
          eventEndTime: item["event"]["endTime"] == null ? DateTime.now() : item["event"]["endTime"],
          eventLocation: item["event"]["location"] == null ? "" : item["event"]["location"],
          eventTitle: item["event"]["title"] == null ? "" : item["event"]["title"]
        );
    }
  }
