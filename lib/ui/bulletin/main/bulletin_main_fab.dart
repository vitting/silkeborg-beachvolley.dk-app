import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';

class BulletinMainFab extends StatefulWidget {
  final ValueChanged<BulletinType> onPressedValue;
  
  const BulletinMainFab({@required this.onPressedValue});

  @override
  _BulletinMainFabState createState() => _BulletinMainFabState();
}

class _BulletinMainFabState extends State<BulletinMainFab>
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
      begin: Colors.deepOrange[700],
      end: Colors.deepOrange[200],
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

  Widget _news() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: Colors.deepOrange[700],
        heroTag: null,
        onPressed: () {
          _close();
          widget.onPressedValue(BulletinType.news);
        },
        tooltip: 'Nyhed',
        child: Icon(FontAwesomeIcons.newspaper),
      ),
    );
  }

  Widget _event() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: Colors.deepOrange[700],
        heroTag: null,
        onPressed: () {
          _close();
          widget.onPressedValue(BulletinType.event);
        },
        tooltip: 'Begivenhed',
        child: Icon(FontAwesomeIcons.calendarAlt),
      ),
    );
  }

  Widget _play() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: Colors.deepOrange[700],
        heroTag: null,
        onPressed: () {
          _close();
          widget.onPressedValue(BulletinType.play);
        },
        tooltip: 'Spil',
        child: Icon(FontAwesomeIcons.volleyballBall),
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
        tooltip: 'Nyt opslag',
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
            _translateButton.value * 3.0,
            0.0,
          ),
          child: _news(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: _event(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: _play(),
        ),
        toggle(),
      ],
    );
  }
}
