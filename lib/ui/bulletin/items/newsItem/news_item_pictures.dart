import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/loader_spinner.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:silkeborgbeachvolley/helpers/image_info_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/image_type.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BulletinNewsItemPictures extends StatelessWidget {
  final List<dynamic> images;
  final List<ImageInfoData> imageInfoData;
  final Function onLongpressImageSelected;
  final BulletinImageType type;
  final bool useSquareOnOddImageCount;
  final bool showImageFullScreen;

  BulletinNewsItemPictures(
      {this.type,
      this.useSquareOnOddImageCount = false,
      this.images,
      this.imageInfoData,
      this.onLongpressImageSelected, this.showImageFullScreen = false});

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
    double fullParentWidth = useSquareOnOddImageCount ? halfParentWidth : constraints.maxWidth;

    if (images != null && type == BulletinImageType.network) {
      switch (images.length) {
        case 1:
          widgets.add(_generateImages1ColumnNetwork(
              fullParentWidth, halfParentWidth, images[0]));
          break;
        case 2:
          widgets.add(_generateImages2ColumnsNetwork(
              halfParentWidth, halfParentWidth, images[0], images[1]));
          break;
        case 3:
          widgets.add(_generateImages2ColumnsNetwork(
              halfParentWidth, halfParentWidth, images[0], images[1]));
          widgets.add(SizedBox(height: 2.0));
          widgets.add(_generateImages1ColumnNetwork(
              fullParentWidth, halfParentWidth, images[2]));
          break;
        case 4:
          widgets.add(_generateImages2ColumnsNetwork(
              halfParentWidth, halfParentWidth, images[0], images[1]));
          widgets.add(SizedBox(height: 2.0));
          widgets.add(_generateImages2ColumnsNetwork(
              halfParentWidth, halfParentWidth, images[2], images[3]));
          break;
      }
    }

    if (imageInfoData != null) {
      switch (imageInfoData.length) {
        case 1:
          widgets.add(_generateImages1ColumnFile(
              fullParentWidth, halfParentWidth, imageInfoData[0]));
          break;
        case 2:
          widgets.add(_generateImages2ColumnsFile(halfParentWidth,
              halfParentWidth, imageInfoData[0], imageInfoData[1]));
          break;
        case 3:
          widgets.add(_generateImages2ColumnsFile(halfParentWidth,
              halfParentWidth, imageInfoData[0], imageInfoData[1]));
          widgets.add(SizedBox(height: 2.0));
          widgets.add(_generateImages1ColumnFile(
              fullParentWidth, halfParentWidth, imageInfoData[2]));
          break;
        case 4:
          widgets.add(_generateImages2ColumnsFile(halfParentWidth,
              halfParentWidth, imageInfoData[0], imageInfoData[1]));
          widgets.add(SizedBox(height: 2.0));
          widgets.add(_generateImages2ColumnsFile(halfParentWidth,
              halfParentWidth, imageInfoData[2], imageInfoData[3]));
          break;
      }
    }

    return widgets;
  }

  Widget _generateImages1ColumnNetwork(double width, double height, String image) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          onLongPress: onLongpressImageSelected != null ? () {
              onLongpressImageSelected(image);
          } : null,
          child: CachedNetworkImage(
            placeholder: LoaderSpinner(
              width: width,
              height: height,
            ),
            errorWidget: Image.memory(kTransparentImage),
            imageUrl: image,
            fit: BoxFit.cover,
            width: width,
            height: height,
          )
        )
      ],
    );
  }

  Widget _generateImages1ColumnFile(
      double width, double height, ImageInfoData image) {
    return Row(
      children: <Widget>[
        GestureDetector(
            onLongPress: () {
              if (onLongpressImageSelected != null)
                onLongpressImageSelected(image);
            },
            child: Image(
              width: width,
              height: height,
              fit: BoxFit.cover,
              image: FileImage(image.imageFile),
            ))
      ],
    );
  }

  Widget _generateImages2ColumnsNetwork(
      double width, double height, String image1, String image2) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 1.0),
          child: GestureDetector(
            onLongPress: () {
              if (onLongpressImageSelected != null)
                onLongpressImageSelected(image1);
            },
            child: CachedNetworkImage(
              placeholder: LoaderSpinner(
                width: width,
                height: height
              ),
              errorWidget: Image.memory(kTransparentImage),
              imageUrl: image1,
              width: width - 1,
              height: height,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 1.0),
          child: GestureDetector(
            onLongPress: () {
              if (onLongpressImageSelected != null)
                onLongpressImageSelected(image2);
            },
            child: CachedNetworkImage(
              placeholder: LoaderSpinner(
                width: width,
                height: height,
              ),
              errorWidget: Image.memory(kTransparentImage),
              imageUrl: image2,
              width: width,
              height: height,
              fit: BoxFit.cover,
            ),
          ),
        )
      ],
    );
  }

  Widget _generateImages2ColumnsFile(
      double width, double height, ImageInfoData image1, ImageInfoData image2) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 1.0),
          child: GestureDetector(
            onLongPress: () {
              if (onLongpressImageSelected != null)
                onLongpressImageSelected(image1);
            },
            child: Image(
              width: width - 1,
              height: height,
              fit: BoxFit.cover,
              image: FileImage(image1.imageFile),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 1.0),
          child: GestureDetector(
            onLongPress: () {
              if (onLongpressImageSelected != null)
                onLongpressImageSelected(image2);
            },
            child: Image(
              width: width,
              height: height,
              fit: BoxFit.cover,
              image: FileImage(image2.imageFile),
            ),
          ),
        )
      ],
    );
  }
}
