import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_theme.dart';

enum WriteToCreateFabType {
  people,
  mail
}

class WriteToCreateFab extends StatefulWidget {
  final ValueChanged<WriteToCreateFabType> onPressedValue;

  const WriteToCreateFab({@required this.onPressedValue});

  @override
  _WriteToCreateFabState createState() => _WriteToCreateFabState();
}

class _WriteToCreateFabState extends State<WriteToCreateFab>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..addListener(() {
            setState(() {});
          });
    _buttonColor = ColorTween(
      begin: SilkeborgBeachvolleyTheme.buttonTextColor,
      end: SilkeborgBeachvolleyTheme.buttonDisabledTextColor,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _people(BuildContext context) {
    return Container(
      child: FloatingActionButton(
        backgroundColor: SilkeborgBeachvolleyTheme.buttonTextColor,
        heroTag: null,
        onPressed: () {
          _close();
          widget.onPressedValue(WriteToCreateFabType.people);
        },
        tooltip: "Ny besked",
        child: Icon(Icons.message),
      ),
    );
  }

  Widget _mail(BuildContext context) {
    return Container(
      child: FloatingActionButton(
        backgroundColor: SilkeborgBeachvolleyTheme.buttonTextColor,
        heroTag: null,
        onPressed: () {
          _close();
          widget.onPressedValue(WriteToCreateFabType.mail);
        },
        tooltip: "Ny e-mail",
        child: Icon(Icons.mail),
      ),
    );
  }

  _close() {
    isOpened = false;
    _animationController.reverse(from: 0.0);
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: _buttonColor.value,
        onPressed: () {
          if (!isOpened) {
            _animationController.forward();
          } else {
            _animationController.reverse();
          }
          isOpened = !isOpened;
        },
        tooltip: "Ny besked",
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: _mail(context),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: _people(context),
        ),
        toggle(),
      ],
    );
  }
}
