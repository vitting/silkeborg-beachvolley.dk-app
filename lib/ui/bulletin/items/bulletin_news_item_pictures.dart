import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/image_info_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_image_type.dart';

class BulletinNewsItemPictures extends StatelessWidget {
  final List<dynamic> images;
  final List<ImageInfoData> imageInfoData;
  final Function onLongpressImageSelected;
  final BulletinImageType type;

  BulletinNewsItemPictures(
      {this.type,
      this.images,
      this.imageInfoData,
      this.onLongpressImageSelected});

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
    print(constraints.maxWidth);
    double halfParentWidth = (constraints.maxWidth / 2).floor().toDouble() - 1;
    double fullParentWidth = constraints.maxWidth;

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

  Widget _generateImages1ColumnNetwork(
      double width, double height, String image) {
    return Row(
      mainAxisSize: MainAxisSize.min,
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
            image: NetworkImage(image),
          ),
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
            child: Image(
              width: width - 1,
              height: height,
              fit: BoxFit.cover,
              image: NetworkImage(image1),
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
              image: NetworkImage(image2),
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
