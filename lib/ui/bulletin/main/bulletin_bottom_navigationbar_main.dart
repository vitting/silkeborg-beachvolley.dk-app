import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/ui/helpers/icon_counter_widget.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';
import './bulletin_main_functions.dart' as bulletinMainFunctions;

class BulletinBottomNavigationBar extends StatefulWidget {
  final Stream<int> bottombarChange;
  final ValueChanged<int> selectedItem;
  final int initValue;

  const BulletinBottomNavigationBar(
      {Key key,
      @required this.initValue,
      @required this.selectedItem,
      @required this.bottombarChange})
      : super(key: key);
  @override
  _BulletinBottomNavigationBarState createState() =>
      _BulletinBottomNavigationBarState();
}

class _BulletinBottomNavigationBarState
    extends State<BulletinBottomNavigationBar> {
  int _bottombarSelected;

  @override
  void initState() {
    super.initState();
    _bottombarSelected = widget.initValue;

    widget.bottombarChange.listen((int selected) {
      _setBottombarItemSelected(selected);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _bottombarSelected,
      onTap: (int value) {
        widget.selectedItem(value);

        _setBottombarItemSelected(value);
      },
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            title: Text(
                bulletinMainFunctions.getTitle(context, BulletinType.news)),
            icon: IconCounter(
              icon: FontAwesomeIcons.newspaper,
              counter: 0,
            )),
        BottomNavigationBarItem(
          title:
              Text(bulletinMainFunctions.getTitle(context, BulletinType.event)),
          icon: IconCounter(
            icon: FontAwesomeIcons.calendarAlt,
            counter: 0,
          ),
        ),
        BottomNavigationBarItem(
          title:
              Text(bulletinMainFunctions.getTitle(context, BulletinType.play)),
          icon: IconCounter(icon: FontAwesomeIcons.volleyballBall, counter: 0),
        )
      ],
    );
  }

  _setBottombarItemSelected(int selected) {
    setState(() {
      _bottombarSelected = selected;
    });
  }
}
