import 'package:flutter/material.dart';

class LivescoreLiveDot extends StatelessWidget {
  final double leftMargin;
  final double rightMargin;
  final double dotSize;
  final Color dotColor;
  final bool showDot;

  const LivescoreLiveDot(
      {Key key,
      this.leftMargin = 0.0,
      this.rightMargin = 0.0,
      this.dotSize = 10.0,
      this.dotColor = Colors.red,
      this.showDot = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return showDot
        ? Container(
            margin: EdgeInsets.only(left: leftMargin, right: rightMargin),
            height: dotSize,
            width: dotSize,
            decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor),
          )
        : Container();
  }
}
