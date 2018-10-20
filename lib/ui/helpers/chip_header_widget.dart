import 'package:flutter/material.dart';

class ChipHeader extends StatelessWidget {
  final String text;
  final double fontSize;
  final TextAlign textAlign;
  final FontWeight fontWeight;
  final Color backgroundColor;
  final Color color;
  final bool expanded;
  final bool roundedCorners;

  const ChipHeader(this.text,
      {this.fontSize = 14.0,
      this.fontWeight = FontWeight.normal,
      this.textAlign = TextAlign.start,
      this.color = Colors.white,
      this.backgroundColor = Colors.blue,
      this.roundedCorners = true,
      this.expanded = false});
  @override
  Widget build(BuildContext context) {
    Widget widgets = Text(text,
        textAlign: textAlign,
        style: TextStyle(
            fontSize: fontSize, color: color, fontWeight: fontWeight));

    if (expanded) {
      widgets = Expanded(child: widgets);
    }

    return Container(
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: roundedCorners ? BorderRadius.circular(6.0) : null),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[widgets],
        ));
  }
}
