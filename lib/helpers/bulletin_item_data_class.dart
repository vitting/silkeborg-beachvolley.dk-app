import 'package:silkeborgbeachvolley/helpers/bulletin_type_enum.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_formatters.dart';

class BulletinItemData {
  String id;
  String type;
  String body;
  DateTime creationDate;
  String authorId;
  String authorName;
  String authorPhotoUrl;
  int numberOfcomments;
  
  BulletinItemData(
      {this.id = "",
      this.type = BulletinType.none,
      this.body = "",
      this.creationDate,
      this.authorId = "",
      this.authorName = "",
      this.authorPhotoUrl = "",
      this.numberOfcomments = 0});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "type": type,
      "body": body,
      "creationDate": creationDate == null ? DateTime.now() : creationDate,
      "author": {
        "id": authorId,
        "name": authorName,
        "photoUrl": authorPhotoUrl
      },
      "numberOfcomments": numberOfcomments
    };
  }

  String get creationDateFormatted =>
      DateTimeFormatters.formatDateDDMMYYYHHNN(creationDate);

  static BulletinItemData fromMap(Map<String, dynamic> item) {
    return new BulletinItemData(
        id: item["id"] == null ? "" : item["id"],
        type: item["type"] == null ? "" : item["type"],
        authorId: item["author"]["id"] == null ? "" : item["author"]["id"],
        authorName:
            item["author"]["name"] == null ? "" : item["author"]["name"],
        authorPhotoUrl: item["author"]["photoUrl"] == null
            ? ""
            : item["author"]["photoUrl"],
        body: item["body"] == null ? "" : item["body"],
        creationDate: item["creationDate"] == null ? "" : item["creationDate"],
        numberOfcomments:
            item["numberOfcomments"] == null ? 0 : item["numberOfcomments"]);
  }
}
