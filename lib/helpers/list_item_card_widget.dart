import 'package:flutter/material.dart';

class ListItemCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const ListItemCard({Key key, this.child, this.padding}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(5.0),
      child: Container(
        padding: padding,
        // decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        //   colors: [
        //     Colors.grey[50],
        //     Colors.grey[100],
        //     Colors.grey[200],
        //   ],
        // )),
        child: child,
      ),
    );
  }
}
