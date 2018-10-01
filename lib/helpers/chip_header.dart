import 'package:flutter/material.dart';

class ChipHeader extends StatelessWidget {
  final String text;
  final double fontSize;
  final TextAlign textAlign;
  final FontWeight fontWeight;

  const ChipHeader(this.text,
      {this.fontSize = 14.0,
      this.fontWeight = FontWeight.normal,
      this.textAlign = TextAlign.start});
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(6.0)),
        child: Text(text,
            textAlign: textAlign,
            style: TextStyle(
                fontSize: fontSize,
                color: Colors.white,
                fontWeight: fontWeight)));
  }
}
