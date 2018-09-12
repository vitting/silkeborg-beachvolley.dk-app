import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:silkeborgbeachvolley/helpers/image_info_data_class.dart';
import 'package:silkeborgbeachvolley/helpers/image_param_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_firestorage.dart';
import 'package:uuid/uuid.dart';

class ImageHelpers {
  static void processImageIsolate(ImageParam param) async {
    final Image imageDecoded = decodeImage(await param.file.readAsBytes());
    Image resizedImage;

    try {
      if (imageDecoded.width >= param.imageSize ||
          imageDecoded.height > param.imageSize) {
        if (imageDecoded.width >= imageDecoded.height) {
          resizedImage = copyResize(imageDecoded, param.imageSize);
        } else {
          resizedImage = copyResize(imageDecoded, -1, param.imageSize);
        }
      } else {
        resizedImage = imageDecoded;
      }

      final File tempFile =
          await File("${param.tempDir.path}/${param.fileName}")
              .writeAsBytes(encodeJpg(resizedImage, quality: 85));

      ImageInfoData imageInfo = ImageInfoData(
          height: resizedImage.height,
          width: resizedImage.width,
          type: "jpg",
          imageFile: tempFile,
          filename: param.fileName);

      param.sendPort.send(imageInfo);
    } catch (e) {
      print("processImage error: $e");
      param.sendPort.send(null);
    }
  }

  static Future<ImageInfoData> saveImage(
      File file, int imageSize, String storageFolder) async {
    ReceivePort receivePort = new ReceivePort();
    ImageParam imageParam = ImageParam(
        file: file,
        sendPort: receivePort.sendPort,
        imageSize: imageSize,
        firebaseStorageFolder: storageFolder,
        fileName: ImageHelpers.createFilename("jpg"),
        tempDir: await getTemporaryDirectory());

    await Isolate.spawn(ImageHelpers.processImageIsolate, imageParam);

    ImageInfoData imageInfo = await receivePort.first;
    
    imageInfo.imagesStoreageFolder = storageFolder;
    
    if (imageInfo.imageFile != null) {
      imageInfo =
          await BulletinFireStorage.saveImageToFirebaseStorage(imageInfo);
    }

    return imageInfo;
  }

  static Future<bool> deleteImageFromCacheAndStorage(
      ImageInfoData image) async {
    try {
      image.imageFile.delete();
      BulletinFireStorage.deleteFromFirebaseStorage(
          image.filename, image.imagesStoreageFolder);
      return true;
    } catch (e) {
      print("_removePhoto: $e");
      return false;
    }
  }

  static String createFilename(String fileExtension) {
    final uuid = new Uuid();
    return "${uuid.v4()}.$fileExtension";
  }
}
