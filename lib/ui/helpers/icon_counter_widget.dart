import 'package:flutter/material.dart';

class IconCounter extends StatelessWidget {
  final IconData icon;
  final int counter;

  const IconCounter({Key key, this.icon, this.counter}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [Icon(icon)];
    if (counter > 0) {
      widgets.add(Positioned(
        right: -10.0,
        child: Container(
          alignment: Alignment.center,
          width: 15.0,
          height: 15.0,
          decoration: BoxDecoration(
            color: Colors.red[600],
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Text(
            counter.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 10.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      ));
    }
    return Stack(
      overflow: Overflow.visible,
      children: widgets,
    );
  }
}
