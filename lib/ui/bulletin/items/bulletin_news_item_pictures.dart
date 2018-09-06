import 'package:flutter/material.dart';

class BulletinNewsItemPictures extends StatelessWidget {
  final List<String> images;

  BulletinNewsItemPictures({this.images});

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
    double fullParentWidth = constraints.maxWidth;

    switch (images.length) {
      case 1:
        widgets.add(_generateImages1Column(halfParentWidth, fullParentWidth, images[0]));
        break;
      case 2:
        widgets.add(_generateImages2Columns(halfParentWidth, halfParentWidth, images[0], images[1]));
        break;
      case 3:
        widgets.add(_generateImages2Columns(halfParentWidth, halfParentWidth, images[0], images[1]));
        widgets.add(SizedBox(height: 2.0));
        widgets.add(_generateImages1Column(halfParentWidth, fullParentWidth, images[2]));     
        break;
      case 4:
        widgets.add(_generateImages2Columns(halfParentWidth, halfParentWidth, images[0], images[1]));
        widgets.add(SizedBox(height: 2.0));
        widgets.add(_generateImages2Columns(halfParentWidth, halfParentWidth, images[2], images[3]));
        break;
    }

    return widgets;
  }

  Widget _generateImages1Column(double width, double height, String image) {
    return Row(
      children: <Widget>[
        Image(
          width: width,
          height: height,
          fit: BoxFit.cover,
          image: AssetImage(image),
        )
      ],
    );
  }

  Widget _generateImages2Columns(
      double width, double height, String image1, String image2) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 1.0),
          child: Image(
            width: width - 1,
            height: height,
            fit: BoxFit.cover,
            image: AssetImage(image1),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 1.0),
          child: Image(
            width: width,
            height: height,
            fit: BoxFit.cover,
            image: AssetImage(image2),
          ),
        )
      ],
    );
  }
}
