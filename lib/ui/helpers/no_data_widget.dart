import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  final String text;

  const NoData(this.text, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(child: Center(child: Text(text))),
    );
  }
}
