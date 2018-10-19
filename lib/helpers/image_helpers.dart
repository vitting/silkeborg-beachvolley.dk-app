import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:silkeborgbeachvolley/helpers/image_info_data.dart';
import 'package:silkeborgbeachvolley/helpers/image_param_data.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_firestorage.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_image_data.dart';
import 'package:uuid/uuid.dart';

class _ResizeImageParam {
  final List<int> fileAsByte;
  final int imageSize;

  _ResizeImageParam(this.fileAsByte, this.imageSize);
}

class _ResizeImageResult {
  final List<int> fileAsByte;
  final int height;
  final int width;

  _ResizeImageResult(this.fileAsByte, this.width, this.height);
}

_ResizeImageResult _reziseImage(_ResizeImageParam testImageInfo) {
  final Image imageDecoded = decodeImage(testImageInfo.fileAsByte);
  Image resizedImage;

  try {
    if (imageDecoded.width >= testImageInfo.imageSize ||
        imageDecoded.height > testImageInfo.imageSize) {
      if (imageDecoded.width >= imageDecoded.height) {
        resizedImage = copyResize(imageDecoded, testImageInfo.imageSize);
      } else {
        resizedImage = copyResize(imageDecoded, -1, testImageInfo.imageSize);
      }
    } else {
      resizedImage = imageDecoded;
    }

    return _ResizeImageResult(encodeJpg(resizedImage, quality: 85),
        resizedImage.width, resizedImage.height);
  } catch (e) {
    print("_reziseImage error: $e");
    return null;
  }
}

class ImageHelpers {
  static Future<ImageInfoData> processImageIsolate(ImageParamData param) async {
    ImageInfoData imageInfo;
    try {
      _ResizeImageResult resizedImage = await compute(_reziseImage, _ResizeImageParam(await param.file.readAsBytes(), param.imageSize));
      
      if (resizedImage != null) {
        final File tempFile =
          await File("${param.tempDir.path}/${param.fileName}")
              .writeAsBytes(resizedImage.fileAsByte);

      imageInfo = ImageInfoData(
          height: resizedImage.height,
          width: resizedImage.width,
          type: "jpg",
          imageFile: tempFile,
          filename: param.fileName);
      }
    
      return imageInfo;
    } catch (e) {
      print("processImage error: $e");
      return null;
    }
  }

  static Future<ImageInfoData> saveImage(
      File file, int imageSize, String storageFolder) async {
    ImageParamData imageParam = ImageParamData(
        file: file,
        imageSize: imageSize,
        firebaseStorageFolder: storageFolder,
        fileName: ImageHelpers.createFilename("jpg"),
        tempDir: await getTemporaryDirectory());

    ImageInfoData imageInfo =
        await ImageHelpers.processImageIsolate(imageParam);

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
      if (image.imageFile != null) {
        image.imageFile.delete();
      }

      BulletinFireStorage.deleteFromFirebaseStorage(
          image.filename, image.imagesStoreageFolder);
      return true;
    } catch (e) {
      print("_removePhoto: $e");
      return false;
    }
  }

  static Future<Null> deleteBulletinImages(
      List<BulletinImageData> images) async {
    try {
      images.forEach((BulletinImageData image) async {
        await image.delete();
      });
    } catch (e) {
      print("ImageHelpers - deleteBulletinImages: $e");
    }
  }

  static Future<Null> deleteBulletinImage(BulletinImageData image) async {
    BulletinFireStorage.deleteFromFirebaseStorage(image.name, image.folder);
  }

  static String createFilename(String fileExtension) {
    final uuid = new Uuid();
    return "${uuid.v4()}.$fileExtension";
  }
}
