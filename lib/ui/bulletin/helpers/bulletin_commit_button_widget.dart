import 'package:flutter/material.dart';

enum ButtonState { add, remove }

class ConfirmButton extends StatelessWidget {
  final ButtonState buttonState;
  final ValueChanged<ButtonState> onPress;
  final String toolTip;

  const ConfirmButton(
      {Key key,
      @required this.buttonState,
      @required this.onPress,
      this.toolTip = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 500),
      opacity: 1.0,
      child: Tooltip(message: toolTip, child: _getIconButton()),
    );
  }

  Widget _getIconButton() {
    Widget iconButton = Container();
    if (buttonState == ButtonState.add) {
      iconButton = IconButton(
          icon: Icon(Icons.check_circle),
          color: Colors.greenAccent,
          iconSize: 40.0,
          onPressed: () {
            onPress(ButtonState.add);
          });
    }
    if (buttonState == ButtonState.remove)
      iconButton = IconButton(
          icon: Icon(Icons.remove_circle),
          color: Colors.blueAccent,
          iconSize: 40.0,
          onPressed: () {
            onPress(ButtonState.remove);
          });

    return iconButton;
  }
}
