import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:silkeborgbeachvolley/helpers/loader_spinner_widget.dart';
import 'package:silkeborgbeachvolley/helpers/notification_data.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_firestore.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/item_main.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/createItem/create_item_main.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/main/bulletin_bottom_navigationbar_main.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/main/bulletin_main_fab.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'package:silkeborgbeachvolley/ui/settings/helpers/settings_data.dart';
import 'package:silkeborgbeachvolley/ui/weather/weather_widget.dart';
import './bulletin_main_functions.dart' as bulletinMainFunctions;

class Bulletin extends StatefulWidget {
  static final routeName = "/bulletin";
  final StreamController<NotificationData> notificationController;

  const Bulletin({Key key, this.notificationController}) : super(key: key);
  @override
  _BulletinState createState() => _BulletinState();
}

class _BulletinState extends State<Bulletin> {
  int _bottombarSelected = 0;
  final int _numberOfItemsToLoadDefault = 20;
  int _listNumberOfItemsToLoad = 20;

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
      title: bulletinMainFunctions
          .getTitle(bulletinMainFunctions.getSelectedType(_bottombarSelected)),
      body: _main(),
      showDrawer: true,
      floatingActionButton: _scaffoldFloatingActionButton(context),
      bottomNavigationBar: BulletinBottomNavigationBar(
        updateCounter: widget.notificationController.stream,
        initValue: _bottombarSelected,
        selectedItem: (int value) {
          if (mounted) {
            setState(() {
              _listNumberOfItemsToLoad = _numberOfItemsToLoadDefault;
              _bottombarSelected = value;
            });
          }
        },
      ),
      actions: <Widget>[
        FutureBuilder(
          future: SettingsData.getSettings(Home.loggedInUser.uid),
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

  Widget _main() {
    return StreamBuilder(
      stream: BulletinFirestore.getBulletinsByTypeAsStream(
          bulletinMainFunctions.getSelectedType(_bottombarSelected),
          _listNumberOfItemsToLoad),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return LoaderSpinner();
        }

        if (snapshot.hasData) {
          if (snapshot.data.documents.length == 0) {
            return Card(
              child: Center(child: Text("Der er ingen opslag")),
            );
          } else {
            return Scrollbar(
              child: ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int position) {
                  if (position == snapshot.data.documents.length - 1 &&
                      snapshot.data.documents.length - 1 ==
                          _listNumberOfItemsToLoad - 1) {
                    return Card(
                        child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton.icon(
                            textColor: Colors.deepOrange,
                            onPressed: () {
                              if (mounted) {
                                setState(() {
                                  _listNumberOfItemsToLoad =
                                      _listNumberOfItemsToLoad * 2;
                                });
                              }
                            },
                            icon: Icon(Icons.refresh),
                            label: Text("Hent flere opslag"),
                          )
                        ],
                      ),
                    ));
                  }

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

  Future<void> _gotoCreateNewsDialog(
      BuildContext context, BulletinType bulletinType) async {
    await Navigator.of(context).push(new MaterialPageRoute<BulletinItemData>(
        builder: (BuildContext context) {
          return new CreateBulletinItem(bulletinType);
        },
        fullscreenDialog: true));
  }
}
