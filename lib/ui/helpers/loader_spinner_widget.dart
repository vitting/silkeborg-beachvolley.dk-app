import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class LoaderSpinner extends StatelessWidget {
  final double width;
  final double height;

  const LoaderSpinner({Key key, this.width, this.height}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      width: width,
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FadeInImage(
            image: AssetImage("assets/images/loader-bar.gif"),
            placeholder: MemoryImage(kTransparentImage),
            height: 5.0,
          )
        ],
      ),
    );
  }
}
