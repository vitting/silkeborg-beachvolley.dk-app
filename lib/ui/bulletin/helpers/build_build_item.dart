import 'package:silkeborgbeachvolley/helpers/image_info_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_image_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/item_fields_create_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/eventItem/event_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/newsItem/news_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/playItem/play_item_data_class.dart';

class BuildBulletinItem {
  static BulletinNewsItemData buildNewsItem(
      ItemFieldsCreate item, List<ImageInfoData> images) {
    return BulletinNewsItemData(
        body: item.body,
        type: item.type,
        id: item.id,
        creationDate: item.creationDate,
        numberOfcomments: item.numberOfcomments,
        images: images.map<BulletinImageData>((ImageInfoData data) {
          return BulletinImageData(
              name: data.filename, folder: data.imagesStoreageFolder, link: data.linkFirebaseStorage);
        }).toList());
  }

  static BulletinPlayItemData buildPlayItem(ItemFieldsCreate item) {
    return BulletinPlayItemData(
      body: item.body, 
      type: item.type,
      id: item.id,
      creationDate: item.creationDate,
      numberOfcomments: item.numberOfcomments,
      numberOfCommits: item.numberOfCommits
    );
  }

  static BulletinEventItemData buildEventItem(
      ItemFieldsCreate item, List<ImageInfoData> images) {
    return BulletinEventItemData(
        id: item.id,
        creationDate: item.creationDate,
        numberOfcomments: item.numberOfcomments,
        body: item.body,
        type: item.type,
        eventTitle: item.eventTitle,
        eventLocation: item.eventLocation,
        eventStartDate: item.eventStartDate,
        eventEndDate: item.eventEndDate,
        eventStartTime: item.eventStartTime,
        eventEndTime: item.eventEndTime,
        eventImage: images.length != 0
            ? BulletinImageData(
                name: images[0].filename,
                folder: images[0].imagesStoreageFolder, link: images[0].linkFirebaseStorage)
            : null);
  }
}
