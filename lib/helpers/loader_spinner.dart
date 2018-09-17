import 'package:flutter/material.dart';

class LoaderSpinner extends StatelessWidget {
  final double width;
  final double height;

  const LoaderSpinner({Key key, this.width, this.height}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
        "assets/images/loader-bar.gif",
        height: 8.0
      )
        ],
      ),
    );
  }
}
