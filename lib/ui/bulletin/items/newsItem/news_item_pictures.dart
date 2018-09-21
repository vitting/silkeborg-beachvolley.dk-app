import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/loader_spinner.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:silkeborgbeachvolley/helpers/image_info_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/image_type.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BulletinNewsItemPictures extends StatelessWidget {
  final List<dynamic> images;
  // final List<ImageInfoData> imageInfoData;
  final Function onLongpressImageSelected;
  final BulletinImageType type;
  final bool useSquareOnOddImageCount;
  final bool showImageFullScreen;

  BulletinNewsItemPictures(
      {this.type,
      this.useSquareOnOddImageCount = false,
      this.images,
      // this.imageInfoData,
      this.onLongpressImageSelected,
      this.showImageFullScreen = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            children: _generateImageMain(constraints),
          );
        },
      ),
    );
  }

  List<Widget> _generateImageMain(BoxConstraints constraints) {
    List<Widget> widgets = [];
    double halfParentWidth = (constraints.maxWidth / 2).floor().toDouble() - 1;
    double fullParentWidth =
        useSquareOnOddImageCount ? halfParentWidth : constraints.maxWidth;

    if (images != null && images.length != 0) {
      switch (images.length) {
        case 1:
          widgets.add(_generateImages1Column(
              type, fullParentWidth, halfParentWidth, images[0]));
          break;
        case 2:
          widgets.add(_generateImages2Columns(
              type, halfParentWidth, halfParentWidth, images[0], images[1]));
          break;
        case 3:
          widgets.add(_generateImages2Columns(
              type, halfParentWidth, halfParentWidth, images[0], images[1]));
          widgets.add(SizedBox(height: 2.0));
          widgets.add(_generateImages1Column(
              type, fullParentWidth, halfParentWidth, images[2]));
          break;
        case 4:
          widgets.add(_generateImages2Columns(
              type, halfParentWidth, halfParentWidth, images[0], images[1]));
          widgets.add(SizedBox(height: 2.0));
          widgets.add(_generateImages2Columns(
              type, halfParentWidth, halfParentWidth, images[2], images[3]));
          break;
      }
    }

    return widgets;
  }

  Widget _getImageWidgetType(
      BulletinImageType type, double width, double height, dynamic image) {
    Widget data = Container();
    if (type == BulletinImageType.network) {
      String link;
      if (image is String) link = image;
      if (image is ImageInfoData) link = image.linkFirebaseStorage;
      data = CachedNetworkImage(
        placeholder: LoaderSpinner(
          width: width,
          height: height,
        ),
        errorWidget: Image.memory(kTransparentImage),
        imageUrl: link,
        fit: BoxFit.cover,
        width: width,
        height: height,
      );
    }

    if (type == BulletinImageType.file) {
      data = Image(
        width: width,
        height: height,
        fit: BoxFit.cover,
        image: FileImage(image.imageFile),
      );
    }

    return data;
  }

  Widget _generateImages1Column(
      BulletinImageType type, double width, double height, dynamic image) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[_getImageContainer(type, width, height, image)],
    );
  }

  Widget _generateImages2Columns(BulletinImageType type, double width,
      double height, dynamic image1, dynamic image2) {
    return Row(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(right: 1.0),
            child: _getImageContainer(type, width, height, image1)),
        Padding(
          padding: const EdgeInsets.only(left: 1.0),
          child: _getImageContainer(type, width, height, image2),
        )
      ],
    );
  }

  Widget _getImageContainer(
      BulletinImageType type, double width, double height, dynamic image) {
    return GestureDetector(
        onLongPress: onLongpressImageSelected != null
            ? () {
                onLongpressImageSelected(image);
              }
            : null,
        child: _getImageWidgetType(type, width, height, image));
  }
}
