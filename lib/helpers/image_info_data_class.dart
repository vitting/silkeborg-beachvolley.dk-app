import 'dart:io';

import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_image_data_class.dart';

class ImageInfoData {
  int width;
  int height;
  String type;
  File imageFile;
  String filename;
  String linkFirebaseStorage;
  String imagesStoreageFolder;

  ImageInfoData({this.imageFile, this.width = 0, this.height = 0, this.type = "", this.filename = "", this.linkFirebaseStorage = "", this.imagesStoreageFolder});

  factory ImageInfoData.fromBulletinImageData(BulletinImageData data) {
    return ImageInfoData(
      filename: data.name,
      type: "jpg",
      imagesStoreageFolder: data.folder,
      linkFirebaseStorage: data.link
    );
  }
}