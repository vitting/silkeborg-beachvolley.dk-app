import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/helpers/firebase_functions_call.dart';
import 'package:silkeborgbeachvolley/helpers/icon_counter_widget.dart';
import 'package:silkeborgbeachvolley/helpers/loader_spinner.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/bulletin_main_fab.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_firestore.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_items_count_data.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_sharedpref.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/item_main.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/createItem/create_item_main.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'package:silkeborgbeachvolley/ui/settings/helpers/settings_data_class.dart';
import 'package:silkeborgbeachvolley/ui/weather/weather_widget.dart';

class Bulletin extends StatefulWidget {
  static final routeName = "/bulletin";
  @override
  _BulletinState createState() => _BulletinState();
}

class _BulletinState extends State<Bulletin> {
  int _bottombarSelected = 0;
  int _newsCount = 0;
  int _eventCount = 0;
  int _playCount = 0;

  @override
  void initState() {
    _loadBulletinItemsCount();
    super.initState();
  }

  _loadBulletinItemsCount() async {
    int dateInMilliSeconds =
        await BulletinSharedPref.getLastCheckedDateInMilliSeconds();
    BulletinItemsCount bulletinItemsCount =
        await FirebaseFunctions.getBulletinsItemCount(dateInMilliSeconds);
    print(
        "News: ${bulletinItemsCount.newsCount} / Events: ${bulletinItemsCount.eventCount} / Plays: ${bulletinItemsCount.playCount}");
    if (mounted) {
      setState(() {
        _newsCount = bulletinItemsCount.newsCount;
        _eventCount = bulletinItemsCount.eventCount;
        _playCount = bulletinItemsCount.playCount;
      });
    }

    BulletinSharedPref.setLastCheckedDateInMilliSeconds(
        DateTime.now().millisecondsSinceEpoch);
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
      title: "Opslag",
      body: _main(),
      showDrawer: true,
      floatingActionButton: _scaffoldFloatingActionButton(context),
      bottomNavigationBar: _scaffoldBottomNavigationBar(),
      actions: <Widget>[
        FutureBuilder(
          future: SettingsData.get(Home.loggedInUser.uid),
          builder:
              (BuildContext context, AsyncSnapshot<SettingsData> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData &&
                snapshot.data.showWeather) return Weather.withWind();
            return Container();
          },
        )
      ],
    );
  }

  Widget _scaffoldFloatingActionButton(BuildContext context) {
    return BulletinMainFab(
      onPressedValue: (BulletinType bulletinType) {
        _gotoCreateNewsDialog(context, bulletinType);
      },
    );
  }

  Widget _scaffoldBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _bottombarSelected,
      onTap: (int value) {
        setState(() {
          _bottombarSelected = value;
        });
      },
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            title: Text("Nyheder"),
            icon: IconCounter(
              icon: FontAwesomeIcons.newspaper,
              counter: _newsCount,
            )),
        BottomNavigationBarItem(
          title: Text("Begivenheder"),
          icon: IconCounter(
            icon: FontAwesomeIcons.calendarAlt,
            counter: _eventCount,
          ),
        ),
        BottomNavigationBarItem(
          title: Text("Spil"),
          icon: IconCounter(
              icon: FontAwesomeIcons.volleyballBall, counter: _playCount),
        )
      ],
    );
  }

  Widget _main() {
    String type = "news";
    if (_bottombarSelected == 0) type = BulletinTypeHelper.news;
    if (_bottombarSelected == 1) type = BulletinTypeHelper.event;
    if (_bottombarSelected == 2) type = BulletinTypeHelper.play;

    return StreamBuilder(
      stream: BulletinFirestore.getBulletinsByTypeAsStream(type),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) return LoaderSpinner();
        return Scrollbar(
          child: ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int position) {
              DocumentSnapshot item = snapshot.data.documents[position];
              return BulletinItemMain(item.data);
            },
          ),
        );
      },
    );
  }

  Future<void> _gotoCreateNewsDialog(
      BuildContext context, BulletinType bulletinType) async {
    await Navigator.of(context).push(new MaterialPageRoute<BulletinItemData>(
        builder: (BuildContext context) {
          return new CreateBulletinItem(bulletinType);
        },
        fullscreenDialog: true));
  }
}
