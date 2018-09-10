import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/system_helpers_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/detailItem/comment_item_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_firestore.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/eventItem/event_item.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/newsItem/news_item.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/playItem/play_item.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/playItem/play_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

class BulletinDetailItem extends StatefulWidget {
  final BulletinItemData bulletinItem;
  BulletinDetailItem(this.bulletinItem);

  @override
  _BulletinDetailItemState createState() => _BulletinDetailItemState();
}

class _BulletinDetailItemState extends State<BulletinDetailItem> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _listScrollController = ScrollController();
  BulletinItemData _bulletinItem;
  int _numberOfComments = 0;
  int _numberOfPlayersCommitted = 0;
  bool _showCommitButtons = false;
  bool _isPlayerCommitted = false;

  @override
  void initState() {
    super.initState();
    _bulletinItem = widget.bulletinItem;
    _numberOfComments = _bulletinItem.numberOfcomments;

    if (_bulletinItem.type == BulletinType.play) {
      _initPlayerCommit();
    }
  }

  _initPlayerCommit() async {
    if (Home.loggedInUser.uid == _bulletinItem.authorId)
      _showCommitButtons = true;
    _numberOfPlayersCommitted =
        (_bulletinItem as BulletinPlayItemData).numberOfPlayersCommitted;

    setState(() async {
      _isPlayerCommitted =
          await (_bulletinItem as BulletinPlayItemData).isCommitted();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
      title: "Silkeborg Beachvolley",
      body: _main(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _listScrollController.animateTo(0.0,
              curve: Curves.fastOutSlowIn,
              duration: Duration(milliseconds: 100));
        },
        child: Icon(Icons.arrow_upward),
      ),
    );
  }

  Widget _main() {
    return ListView(
      controller: _listScrollController,
      children: <Widget>[
        _createBulletinMainItem(),
        _addComment(),
        StreamBuilder(
          stream: BulletinFirestore.getAllBulletinComments(_bulletinItem.id),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData)
              return Center(child: Image.asset("assets/images/loader-bar.gif"));
            _numberOfComments = snapshot.data.documents.length;
            return Column(
                children: snapshot.data.documents
                    .map<Widget>((DocumentSnapshot document) {
              return Card(
                child: _commentField(document.data),
              );
            }).toList());
          },
        )
      ],
    );
  }

  Widget _createBulletinMainItem() {
    var item;
    switch (_bulletinItem.type) {
      case BulletinType.news:
        item = Card(
            child: BulletinNewsItem(
          bulletinItem: _bulletinItem,
          numberOfComments: _numberOfComments,
        ));
        break;
      case BulletinType.event:
        item = Card(
            child: BulletinEventItem(
          bulletinItem: _bulletinItem,
          numberOfComments: _numberOfComments,
        ));
        break;
      case BulletinType.play:
        item = Card(
            child: BulletinPlayItem(
          bulletinItem: _bulletinItem,
          numberOfComments: _numberOfComments,
          numberOfPlayersCommitted: _numberOfPlayersCommitted,
          showCommitButtons: _showCommitButtons,
          isPlayerCommitted: _isPlayerCommitted,
          onPressedPlayerCommit: _onPressedplayerCommit,
        ));
        break;
    }

    return item;
  }

  _onPressedplayerCommit(PlayerCommitStatus status) {
    bool state = false;
    if (status == PlayerCommitStatus.commit) {
      (_bulletinItem as BulletinPlayItemData).setPlayerAsCommitted();
      state = true;
    } else {
      (_bulletinItem as BulletinPlayItemData).setPlayerAsUnCommitted();
    }

    setState(() {
      _isPlayerCommitted = state;
    });
  }

  Widget _addComment() {
    BulletinCommentItem bulletinCommentItem = new BulletinCommentItem();
    return ListBody(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: TextFormField(
              onSaved: (String value) {
                bulletinCommentItem.body = value;
              },
              validator: (String value) {
                if (value.isEmpty) return "Skal ydfyldes";
              },
              decoration: InputDecoration(
                  labelText: "Skriv en kommentar",
                  suffixIcon: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          _formKey.currentState.reset();
                          await _saveBulletinCommentItem(bulletinCommentItem);
                          SystemHelpers.hideKeyboardWithNoFocus(context);
                        }
                      })),
            ),
          ),
        ),
      ],
    );
  }

  Widget _commentField(Map<String, dynamic> item) {
    BulletinCommentItem _bulletinCommentItem =
        BulletinCommentItem.fromMap(item);
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(_bulletinCommentItem.authorName),
          Row(
            children: <Widget>[
              Icon(Icons.access_time, size: 10.0),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(_bulletinCommentItem.creationDateFormatted,
                    style: TextStyle(fontSize: 10.0)),
              )
            ],
          )
        ],
      ),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(_bulletinCommentItem.authorPhotoUrl),
      ),
      subtitle: Text(_bulletinCommentItem.body),
    );
  }

  Future<void> _saveBulletinCommentItem(BulletinCommentItem item) async {
    FirebaseUser _user = Home.loggedInUser;
    item.authorId = _user.uid;
    item.authorName = _user.displayName;
    item.authorPhotoUrl = _user.photoUrl;
    item.creationDate = DateTime.now();
    item.id = _bulletinItem.id;
    await BulletinFirestore.saveCommentItem(item);
  }
}
