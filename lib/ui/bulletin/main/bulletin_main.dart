import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/ui/main_inheretedwidget.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_widget.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_firestore.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_item_data.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/item_main.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/createItem/create_item_main.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/main/bulletin_bottom_navigationbar_main.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/main/bulletin_main_fab.dart';
import 'package:silkeborgbeachvolley/ui/helpers/no_data_widget.dart';
import 'package:silkeborgbeachvolley/ui/notifications/notification_button_widget.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'package:silkeborgbeachvolley/ui/weather/weather_widget.dart';
import './bulletin_main_functions.dart' as bulletinMainFunctions;

class Bulletin extends StatefulWidget {
  static final routeName = "/bulletin";
  @override
  _BulletinState createState() => _BulletinState();
}

class _BulletinState extends State<Bulletin> {
  final StreamController<int> _bottombarStreamController =
      StreamController<int>.broadcast();
  final ScrollController _scrollController = ScrollController();
  final _defaultNumberOfItemsToLoad = 20;
  int _numberOfItemsToLoad;
  int _currentLengthOfLoadedItems = 0;
  Widget _weatherCache;
  int _bottombarSelected = 0;

  @override
  void initState() {
    super.initState();
    _numberOfItemsToLoad = _defaultNumberOfItemsToLoad;
    _scrollController.addListener(_handleScrollLoadMore);
  }

  @override
  void dispose() {
    super.dispose();
    _bottombarStreamController.close();
    _scrollController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setWeather();
  }

  void _setWeather() {
    _weatherCache = MainInherited.of(context).settings.showWeather
        ? Weather.withWind()
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
      title: bulletinMainFunctions.getTitle(
          context, bulletinMainFunctions.getSelectedType(_bottombarSelected)),
      body: _main(),
      showDrawer: true,
      floatingActionButton: _scaffoldFloatingActionButton(context),
      bottomNavigationBar: BulletinBottomNavigationBar(
        bottombarChange: _bottombarStreamController.stream,
        initValue: _bottombarSelected,
        selectedItem: (int selected) {
          _setBottomBarValue(selected);
        },
      ),
      actions: <Widget>[
        NotiticationButton(
          onBulletinSelected: (int bottomBarToSelect) {
            _bottombarStreamController.add(bottomBarToSelect);
            _setBottomBarValue(bottomBarToSelect);
          },
        ),
        InkWell(
          child: _weatherCache,
          onTap: () {
            setState(() {
              _setWeather();
            });
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

  Widget _main() {
    return StreamBuilder(
      stream: BulletinFirestore.getBulletinsByTypeAsStream(
          bulletinMainFunctions.getSelectedType(_bottombarSelected),
          _numberOfItemsToLoad),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print("ERROR bulletin_main StreamBuilder: ${snapshot.error}");
          return Container();
        }

        if (!snapshot.hasData) {
          return LoaderSpinner();
        }

        if (snapshot.hasData) {
          if (snapshot.data.documents.length == 0) {
            return NoData(FlutterI18n.translate(
                context, "bulletin.bulletinMain.string1"));
          } else {
            _currentLengthOfLoadedItems = snapshot.data.documents.length;

            return Scrollbar(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int position) {
                  DocumentSnapshot item = snapshot.data.documents[position];

                  return BulletinItemMain(item.data);
                },
              ),
            );
          }
        }
      },
    );
  }

  void _setBottomBarValue(int selected) {
    setState(() {
      _numberOfItemsToLoad = _defaultNumberOfItemsToLoad;
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0.0);
      }

      
      _currentLengthOfLoadedItems = 0;
      _bottombarSelected = selected;
    });
  }

  Future<void> _gotoCreateNewsDialog(
      BuildContext context, BulletinType bulletinType) async {
    await Navigator.of(context).push(new MaterialPageRoute<BulletinItemData>(
        builder: (BuildContext context) {
          return new CreateBulletinItem(bulletinType);
        },
        fullscreenDialog: true));
  }

  void _handleScrollLoadMore() {
    if (_scrollController.position.extentAfter == 0) {
      if (_currentLengthOfLoadedItems >= _numberOfItemsToLoad)
        setState(() {
          _numberOfItemsToLoad =
              _numberOfItemsToLoad + _defaultNumberOfItemsToLoad;
        });
    }
  }
}
