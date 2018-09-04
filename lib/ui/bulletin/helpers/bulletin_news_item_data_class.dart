import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';

class BulletinNewsItemData extends BulletinItemData {
  BulletinNewsItemData(
      {String id = "",
      String type = BulletinType.none,
      String body = "",
      DateTime creationDate,
      String authorId = "",
      String authorName = "",
      String authorPhotoUrl = "",
      int numberOfcomments = 0})
      : super(
            id: id,
            type: type,
            body: body,
            creationDate: creationDate,
            authorId: authorId,
            authorName: authorName,
            authorPhotoUrl: authorPhotoUrl,
            numberOfcomments: numberOfcomments);

  static BulletinNewsItemData fromMap(Map<String, dynamic> item) {
    return new BulletinNewsItemData(
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
