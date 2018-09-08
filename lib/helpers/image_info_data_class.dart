import 'dart:io';

class ImageInfoData {
  int width;
  int height;
  String type;
  File imageFile;
  String filename;
  String linkFirebaseStorage;

  ImageInfoData({this.imageFile, this.width = 0, this.height = 0, this.type = "", this.filename = "", this.linkFirebaseStorage = ""});
}