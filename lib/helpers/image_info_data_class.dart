import 'dart:io';

class ImageInfoData {
  int width;
  int height;
  String type;
  File imageFile;
  String filename;
  String linkFirebaseStorage;
  String imagesStoreageFolder;

  ImageInfoData({this.imageFile, this.width = 0, this.height = 0, this.type = "", this.filename = "", this.linkFirebaseStorage = "", this.imagesStoreageFolder});
}