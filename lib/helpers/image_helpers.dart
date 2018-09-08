import 'dart:async';
import 'dart:io';

import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:silkeborgbeachvolley/helpers/image_info_data_class.dart';
import 'package:uuid/uuid.dart';

class ImageHelpers {
  static Future<ImageInfoData> processImage(File imageFile, int maxImageSize) async {
    final uuid = new Uuid();
    final Image imageDecoded = decodeImage(await imageFile.readAsBytes());
    Image resizedImage;
    
    try {
      if (imageDecoded.width >= maxImageSize || imageDecoded.height > maxImageSize) {
        if (imageDecoded.width >= imageDecoded.height) {
          resizedImage = copyResize(imageDecoded, maxImageSize);
        } else {
          resizedImage = copyResize(imageDecoded, -1, maxImageSize);
        }
      } else {
        resizedImage = imageDecoded;
      }

      final Directory tempDir = await getTemporaryDirectory();
      final String tempFilename = "${uuid.v4()}.jpg";
      final File tempFile = await File("${tempDir.path}/$tempFilename")
          .writeAsBytes(encodeJpg(resizedImage, quality: 85));
      
      return ImageInfoData(
        height: resizedImage.height,
        width: resizedImage.width,
        type: "jpg",
        imageFile: tempFile,
        filename: tempFilename
      );
    } catch (e) {
      print("processNewsImage error: $e");
      return null;
    }
  }
}