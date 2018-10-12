import 'package:flutter/material.dart';

class ListItemCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Widget title;
  const ListItemCard({Key key, this.child, this.padding, this.title})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];

    if (title != null) {
      widgets.add(Container(
          color: Color(0xffaaacb5),
          padding: EdgeInsets.all(10.0),
          child: title));
    }

    widgets.add(child);
    return Card(
      margin: EdgeInsets.all(5.0),
      child: Container(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgets,
        ),
      ),
    );
  }
}
