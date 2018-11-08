import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/helpers/firebase_functions_call.dart';
import 'package:silkeborgbeachvolley/ui/helpers/icon_counter_widget.dart';
import 'package:silkeborgbeachvolley/helpers/notification_data.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_items_count_data.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_sharedpref.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';
import 'package:silkeborgbeachvolley/ui/main_inheretedwidget.dart';
import './bulletin_main_functions.dart' as bulletinMainFunctions;

class BulletinBottomNavigationBar extends StatefulWidget {
  final ValueChanged<int> selectedItem;
  final int initValue;
 
  const BulletinBottomNavigationBar(
      {Key key,
      @required this.initValue,
      @required this.selectedItem,
      })
      : super(key: key);
  @override
  _BulletinBottomNavigationBarState createState() =>
      _BulletinBottomNavigationBarState();
}

class _BulletinBottomNavigationBarState
    extends State<BulletinBottomNavigationBar> {
  int _bottombarSelected;
  int _newsCount = 0;
  int _eventCount = 0;
  int _playCount = 0;

  @override
  void initState() {
    super.initState();
    _bottombarSelected = widget.initValue;
    _setBulletinItemsCount(null);
  }

  @override
    void didChangeDependencies() {
      super.didChangeDependencies();

      MainInherited.of(context, false).notificationsAsStream.listen((NotificationData value) {
        _setBulletinItemsCount(value);
      });
    }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _bottombarSelected,
      onTap: (int value) {
        widget.selectedItem(value);

        setState(() {
          _bottombarSelected = value;

          switch (value) {
            case 0:
              _newsCount = 0;
              break;
            case 1:
              _eventCount = 0;
              break;
            case 2:
              _playCount = 0;
              break;
          }
        });
      },
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            title: Text(
                bulletinMainFunctions.getTitle(context, BulletinType.news)),
            icon: IconCounter(
              icon: FontAwesomeIcons.newspaper,
              counter: _newsCount,
            )),
        BottomNavigationBarItem(
          title:
              Text(bulletinMainFunctions.getTitle(context, BulletinType.event)),
          icon: IconCounter(
            icon: FontAwesomeIcons.calendarAlt,
            counter: _eventCount,
          ),
        ),
        BottomNavigationBarItem(
          title:
              Text(bulletinMainFunctions.getTitle(context, BulletinType.play)),
          icon: IconCounter(
              icon: FontAwesomeIcons.volleyballBall, counter: _playCount),
        )
      ],
    );
  }

  _setBulletinItemsCount(NotificationData value) async {
    int newsCount = _newsCount;
    int eventCount = _eventCount;
    int playCount = _playCount;

    if (value != null &&
        value.state == NotificationState.message &&
        value.bulletinType.isNotEmpty) {
      switch (value.bulletinType) {
        case BulletinTypeHelper.news:
          newsCount++;
          break;
        case BulletinTypeHelper.event:
          eventCount++;
          break;
        case BulletinTypeHelper.play:
          playCount++;
          break;
      }
    } else {
      int dateInMilliSeconds =
          await BulletinSharedPref.getLastCheckedDateInMilliSeconds();
      BulletinItemsCount bulletinItemsCount =
          await FirebaseFunctions.getBulletinsItemCount(dateInMilliSeconds);
      newsCount = bulletinItemsCount.newsCount;
      eventCount = bulletinItemsCount.eventCount;
      playCount = bulletinItemsCount.playCount;

      BulletinSharedPref.setLastCheckedDateInMilliSeconds(
          DateTime.now().millisecondsSinceEpoch);
    }

    if (mounted) {
      setState(() {
        _newsCount = newsCount;
        _eventCount = eventCount;
        _playCount = playCount;
        if (_bottombarSelected == 0) {
          _newsCount = 0;
        }

        if (_bottombarSelected == 1) {
          _eventCount = 0;
        }

        if (_bottombarSelected == 2) {
          _playCount = 0;
        }
      });
    }
  }
}
