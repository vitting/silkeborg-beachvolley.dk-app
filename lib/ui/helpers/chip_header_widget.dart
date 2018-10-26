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
  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;
  final Widget child;
  
  const ChipHeader(this.text,
      {this.fontSize = 14.0,
      this.fontWeight = FontWeight.normal,
      this.textAlign = TextAlign.start,
      this.color = Colors.white,
      this.backgroundColor = Colors.blue,
      this.roundedCorners = true,
      this.expanded = false,
      this.paddingBottom = 5.0,
      this.paddingLeft = 5.0,
      this.paddingRight = 5.0,
      this.paddingTop = 5.0,
      this.child
    });
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
        padding: EdgeInsets.fromLTRB(paddingLeft, paddingTop, paddingRight, paddingBottom),
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: roundedCorners ? BorderRadius.circular(6.0) : null),
        child: child == null ? Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            widgets
            ],
        ) : child);
  }
}
