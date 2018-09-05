import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';

class BulletinCommentItem {
  String id;
  String body;
  DateTime creationDate;
  String authorId;
  String authorName;
  String authorPhotoUrl;

  BulletinCommentItem(
      {this.id = "",
      this.body = "",
      this.creationDate,
      this.authorId = "",
      this.authorName = "",
      this.authorPhotoUrl = ""});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "body": body,
      "creationDate": creationDate,
      "author": {"id": authorId, "name": authorName, "photoUrl": authorPhotoUrl}
    };
  }

  static fromMap(Map<String, dynamic> item) {
    return new BulletinCommentItem(
        id: item["id"] == null ? "" : item["id"],
        body: item["body"] == null ? "" : item["body"],
        creationDate: item["creationDate"] == null
            ? DateTime.now()
            : item["creationDate"],
        authorId: item["author"]["id"] == null ? "" : item["author"]["id"],
        authorName:
            item["author"]["name"] == null ? "" : item["author"]["name"],
        authorPhotoUrl: item["author"]["photoUrl"] == null
            ? ""
            : item["author"]["photoUrl"]);
  }

  String get creationDateFormatted =>
      DateTimeHelpers.ddmmyyyyHHnn(creationDate);
}
