import 'package:silkeborgbeachvolley/helpers/bulletin_item_data_class.dart';
import 'package:silkeborgbeachvolley/helpers/bulletin_type_enum.dart';

class BulletinEventItemData extends BulletinItemData {
  DateTime eventDate;
  DateTime eventStart;
  DateTime eventEnd;

  BulletinEventItemData(
      {String id = "",
      String type = BulletinType.none,
      String body = "",
      DateTime creationDate,
      String authorId = "",
      String authorName = "",
      String authorPhotoUrl = "",
      int numberOfcomments = 0,
      this.eventDate,
      this.eventEnd,
      this.eventStart})
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
      "event": {"date": eventDate, "start": eventStart, "end": eventEnd}
    });

    return map;
  }

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
        eventDate: item["event"]["date"] == null ? DateTime.now() : item["event"]["date"],
        eventStart: item["event"]["start"] == null ? DateTime.now() : item["event"]["start"],
        eventEnd: item["event"]["end"] == null ? DateTime.now() : item["event"]["end"]
      );
  }  
}
