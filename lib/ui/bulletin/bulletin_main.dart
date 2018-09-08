import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/helpers/loader_spinner.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_firestore.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/bulletin_item_main.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/createItem/bulletin_create_item_main.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

class Bulletin extends StatefulWidget {
  static final routeName = "/bulletin";
  @override
  _BulletinState createState() => _BulletinState();
}

class _BulletinState extends State<Bulletin> {
  int _bottombarSelected = 0;

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
      title: "Opslag",
      body: _main(),
      showDrawer: true,
      floatingActionButton: _scaffoldFloatingActionButton(context),
      bottomNavigationBar: _scaffoldBottomNavigationBar(),
    );
  }

Widget _scaffoldFloatingActionButton(BuildContext context) {
  return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _gotoCreateNewsDialog(context);
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
          icon: Icon(FontAwesomeIcons.newspaper),
        ),
        BottomNavigationBarItem(
          title: Text("Begivenheder"),
          icon: Icon(FontAwesomeIcons.calendarAlt),
        ),
        BottomNavigationBarItem(
          title: Text("Spil"),
          icon: Icon(FontAwesomeIcons.volleyballBall),
        )
      ],
    );
  }

  Widget _main() {
    String type = "news";
    if (_bottombarSelected == 0) type = "news";
    if (_bottombarSelected == 1) type = "event";
    if (_bottombarSelected == 2) type = "play";

    return StreamBuilder(
      stream: BulletinFirestore.getBulletinsByTypeAsStream(type),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData)
          return LoaderSpinner();

        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (BuildContext context, int position) {
            DocumentSnapshot item = snapshot.data.documents[position];
            return BulletinItemMain(item.data, type);
          },
        );
      },
    );
  }

  Future<void> _gotoCreateNewsDialog(BuildContext context) async {
    await Navigator.of(context)
        .push(new MaterialPageRoute<BulletinItemData>(
            builder: (BuildContext context) {
              return new CreateBulletinItem();
            },
            fullscreenDialog: true));
  }
}
