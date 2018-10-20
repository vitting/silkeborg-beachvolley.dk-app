import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:silkeborgbeachvolley/helpers/image_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/image_info_data.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_image_helpers.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/photo_add_photo_widget.dart';

Future<ImageInfoData> addPhoto(
    BuildContext context, BulletinType bulletinType) async {
  return await showModalBottomSheet<Future<ImageInfoData>>(
      context: context,
      builder: (BuildContext context) {
        return PhotoAddPhoto(
          menuItemOnTap: (String value) {
            Navigator.of(context).pop(selectPhoto(value, bulletinType));
          },
        );
      });
}

Future<ImageInfoData> selectPhoto(
    String mode, BulletinType bulletinType) async {
  ImageInfoData imageInfo;
  File imageFile = await ImagePicker.pickImage(
      source: mode == "gallery" ? ImageSource.gallery : ImageSource.camera);
  if (imageFile != null) {
    imageInfo = await ImageHelpers.saveImage(
        imageFile,
        BulletinImageHelpers.getImageSize(bulletinType),
        BulletinImageHelpers.getStorageFolder(bulletinType));
  }

  return imageInfo;
}

Future<PhotoAction> removePhoto(BuildContext context) async {
  return showModalBottomSheet<PhotoAction>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.delete),
                title: Text("Fjern billede"),
                onTap: () {
                  Navigator.of(context).pop(PhotoAction.delete);
                },
              )
            ],
          ),
        );
      });
}

removeImagesFromCacheAndStorage(List<ImageInfoData> imageFiles) {
  if (imageFiles.length > 0) {
    imageFiles.forEach((ImageInfoData image) async {
      if (image.imageFile != null)
        await ImageHelpers.deleteImageFromCacheAndStorage(image);
    });
  }
}

enum PhotoAction { delete }
