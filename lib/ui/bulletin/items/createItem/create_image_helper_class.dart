import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';

class CreateImageHelper {
  static int getImageSize(String type) {
    int size = 0;
    if (type == BulletinType.event) size = 90;
    if (type == BulletinType.news) size = 1200;
    return size;
  }

  static String getStorageFolder(String type) {
    String folder = "";
    if (type == BulletinType.event) folder = "eventImages";
    if (type == BulletinType.news) folder = "newsImages";

    return folder;
  }
}