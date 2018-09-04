import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_firestore.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/bulletin_item_main.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/createItem/create_bulletin_item_main.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

class Bulletin extends StatefulWidget {
  @override
  _BulletinState createState() => _BulletinState();
}

class _BulletinState extends State<Bulletin> {
  int _bottombarSelected = 0;

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
      title: "Silkeborg Beachvolley",
      body: _main(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _gotoCreateNewsDialog(context);
        },
      ),
      actions: _scaffoldActions(context),
      bottomNavigationBar: _scaffoldBottomNavigationBar(),
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
          icon: Icon(FontAwesomeIcons.calendarTimes),
        ),
        BottomNavigationBarItem(
          title: Text("Spil"),
          icon: Icon(FontAwesomeIcons.volleyballBall),
        )
      ],
    );
  }

  List<Widget> _scaffoldActions(BuildContext context) {
    return [
      PopupMenuButton<int>(
        initialValue: 1,
        onSelected: (value) async {
          if (value == 1) {
            Navigator.pushNamed(context, "/settings");
          }
        },
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem(
              child: Text("Indstillinger"),
              value: 1,
            )
          ];
        },
        icon: Icon(Icons.more_vert),
      )
    ];
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
          return Center(child: Image.asset("assets/images/loader-bar.gif"));

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

  Future _gotoCreateNewsDialog(BuildContext context) async {
    BulletinItemData bulletinItem = await Navigator.of(context)
        .push(new MaterialPageRoute<BulletinItemData>(
            builder: (BuildContext context) {
              return new CreateBulletinItem();
            },
            fullscreenDialog: true));

    if (bulletinItem != null) {
      print(bulletinItem.body + "/" + bulletinItem.type.toString());
    }
  }
}
