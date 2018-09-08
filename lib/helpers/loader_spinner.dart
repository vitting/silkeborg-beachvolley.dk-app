import 'package:flutter/material.dart';

class LoaderSpinner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        "assets/images/loader-bar.gif",
        height: 10.0
      ),
    );
  }
}
