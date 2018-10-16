import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

enum DotBottomBarButton { left, right, both }

class DotBottomBar extends StatelessWidget {
  final int position;
  final int numberOfDot;
  final ValueChanged<DotBottomBarButton> onPressed;
  final bool showNavigationButtons;
  final DotBottomBarButton navigationButtonsToShow;
  final bool navigationButtonsAutoShow;
  final String labelLeft;
  final String labelRight;
  const DotBottomBar(
      {@required this.position,
      @required this.numberOfDot,
      this.onPressed,
      this.showNavigationButtons = false,
      this.navigationButtonsToShow = DotBottomBarButton.both,
      this.labelLeft = "",
      this.labelRight = "",
      this.navigationButtonsAutoShow = true});
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        color: Colors.blue,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: _getButton(DotBottomBarButton.left),
            ),
            Expanded(flex: 2, child: _getLabel(labelLeft)),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  DotsIndicator(
                    dotActiveColor: Colors.white,
                    numberOfDot: numberOfDot,
                    position: position,
                  )
                ],
              ),
            ),
            Expanded(flex: 2, child: _getLabel(labelRight)),
            Expanded(
              flex: 1,
              child: _getButton(DotBottomBarButton.right),
            ),
          ],
        ));
  }

  Text _getLabel(String label) {
    return Text(label,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 12.0));
  }

  Widget _getButton(DotBottomBarButton direction) {
    Widget button = SizedBox();
    if (showNavigationButtons) {
      if (navigationButtonsAutoShow) {
        if (direction == DotBottomBarButton.left &&
            navigationButtonsToShow == DotBottomBarButton.right) return button;
        if (direction == DotBottomBarButton.right &&
            navigationButtonsToShow == DotBottomBarButton.left) return button;
        if (numberOfDot == 1) return button;
        if (direction == DotBottomBarButton.left && position == 0)
          return button;
        if (direction == DotBottomBarButton.right &&
            position == numberOfDot - 1) return button;
      }

      IconData icon = direction == DotBottomBarButton.left
          ? Icons.arrow_back
          : Icons.arrow_forward;
      AlignmentGeometry alignmentGeometry = direction == DotBottomBarButton.left
          ? AlignmentDirectional.centerStart
          : AlignmentDirectional.centerEnd;
      button = IconButton(
        alignment: alignmentGeometry,
        onPressed: () {
          onPressed(direction);
        },
        icon: Icon(icon, color: Colors.white),
      );
    }

    return button;
  }
}
