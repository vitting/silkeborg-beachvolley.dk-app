import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/image_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/uuid_helpers.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_firestore.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_image_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';

class BulletinEventItemData extends BulletinItemData {
  DateTime eventStartDate;
  DateTime eventEndDate;
  dynamic eventStartTime;
  dynamic eventEndTime;
  String eventLocation;
  String eventTitle;
  BulletinImageData eventImage;

  BulletinEventItemData(
      {String id,
      BulletinType type,
      String body = "",
      DateTime creationDate,
      String authorId,
      String authorName,
      String authorPhotoUrl,
      int numberOfcomments = 0,
      List<dynamic> hiddenByUser,
      this.eventStartDate,
      this.eventEndDate,
      this.eventEndTime,
      this.eventStartTime,
      this.eventLocation,
      this.eventTitle,
      this.eventImage})
      : super(
            id: id,
            type: type,
            body: body,
            creationDate: creationDate,
            authorId: authorId,
            authorName: authorName,
            authorPhotoUrl: authorPhotoUrl,
            hiddenByUser: hiddenByUser,
            numberOfcomments: numberOfcomments);

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();
    map.addAll({
      "event": {
        "startDate": eventStartDate,
        "endDate": eventEndDate,
        "startTime": eventStartTime,
        "endTime": eventEndTime,
        "location": eventLocation,
        "title": eventTitle,
        "image": {
          "name": eventImage?.name ?? "",
          "folder": eventImage?.folder ?? "",
          "link": eventImage?.link ?? ""
        }
      }
    });

    return map;
  }

  String get evnetStartDateFormatted =>
      DateTimeHelpers.ddmmyyyy(eventStartDate);

  String get eventEndDateFormatted => DateTimeHelpers.ddmmyyyy(eventStartDate);

  ///Deletes all images, comments and the event item.
  @override
  Future<bool> delete() async {
    try {
      if (eventImage != null) {
        await ImageHelpers.deleteBulletinImage(eventImage);
      }

      return super.delete();
    } catch (e) {
      print("EventItemData - delete() : $e");
      return false;
    }
  }

  Future<void> save() {
     id = id ?? UuidHelpers.generateUuid();
    creationDate = creationDate ?? FieldValue.serverTimestamp();
    authorId = Home.loggedInUser.uid;
    authorName = Home.loggedInUser.displayName;
    authorPhotoUrl = Home.loggedInUser.photoUrl;
    DateTime start = DateTime(eventStartDate.year, eventStartDate.month,
        eventStartDate.day, eventStartTime.hour, eventStartTime.minute);

    DateTime end = DateTime(eventEndDate.year, eventEndDate.month,
        eventEndDate.day, eventEndTime.hour, eventEndTime.minute);

    eventStartDate = start;
    eventEndDate = end;
    eventStartTime = start;
    eventEndTime = end;
    return BulletinFirestore.saveBulletinItem(this);
  }

  factory BulletinEventItemData.fromMap(Map<String, dynamic> item) {
    return new BulletinEventItemData(
        id: item["id"] ?? "",
        type: BulletinTypeHelper.getBulletinTypeStringAsType(item["type"]),
        authorId: item["author"]["id"] ?? "",
        authorName: item["author"]["name"] ?? "",
        authorPhotoUrl: item["author"]["photoUrl"] ?? "",
        body: item["body"] ?? "",
        creationDate: item["creationDate"] ?? DateTime.now(),
        numberOfcomments: item["numberOfcomments"] ?? 0,
        eventStartDate: item["event"]["startDate"] ?? DateTime.now(),
        eventEndDate: item["event"]["endDate"] ?? DateTime.now(),
        eventStartTime: item["event"]["startTime"] ?? DateTime.now(),
        eventEndTime: item["event"]["endTime"] ?? DateTime.now(),
        eventLocation: item["event"]["location"] ?? "",
        eventTitle: item["event"]["title"] ?? "",
        eventImage: item["event"]["image"] == null ? null : BulletinImageData.fromMap(item["event"]["image"])
        );
  }
}
