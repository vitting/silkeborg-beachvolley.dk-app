import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/image_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/uuid_helpers.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_firestore.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_image_data.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_item_data.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';

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
      Timestamp creationDate,
      String authorId,
      String authorName,
      String authorPhotoUrl,
      int numberOfcomments = 0,
      int numberOfCommits = 0,
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
            numberOfCommits: numberOfCommits,
            numberOfcomments: numberOfcomments);

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();
    map.addAll({
      "event": {
        "startDate": Timestamp.fromDate(eventStartDate),
        "endDate": Timestamp.fromDate(eventEndDate),
        "startTime": Timestamp.fromDate(eventStartTime),
        "endTime": Timestamp.fromDate(eventEndTime),
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

  String get eventStartDateFormatted =>
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

  Future<void> save(FirebaseUser user) {
    id = id ?? UuidHelpers.generateUuid();
    creationDate = creationDate ?? Timestamp.now();
    authorId = user.uid;
    authorName = user.displayName;
    authorPhotoUrl = user.photoUrl;
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
      creationDate: item["creationDate"],
      numberOfcomments: item["numberOfcomments"] ?? 0,
      numberOfCommits: item["numberOfCommits"] ?? 0,
      eventStartDate: (item["event"]["startDate"] as Timestamp).toDate(),
      eventEndDate: (item["event"]["endDate"] as Timestamp).toDate(),
      eventStartTime: (item["event"]["startTime"] as Timestamp).toDate(),
      eventEndTime: (item["event"]["endTime"] as Timestamp).toDate(),
      eventLocation: item["event"]["location"] ?? "",
      eventTitle: item["event"]["title"] ?? "",
      eventImage: item["event"]["image"] == null
          ? null
          : BulletinImageData.fromMap(item["event"]["image"]),
    );
  }
}
