import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/local_user_info_class.dart';
import 'package:silkeborgbeachvolley/helpers/system_helpers_class.dart';
import 'package:silkeborgbeachvolley/helpers/userauth.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_comment_item_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_firestore.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/bulletin_event_item.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/bulletin_news_item.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/bulletin_play_item.dart';
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
  var _bulletinItem;
  int _numberOfComments = 0;

  @override
  void initState() {
    super.initState();
    _bulletinItem = widget.bulletinItem;
    _numberOfComments = _bulletinItem.numberOfcomments;
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
                !snapshot.hasData) return Center(child: Image.asset("assets/images/loader-bar.gif"));
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
      case "news":
        item = Card(
          child: BulletinNewsItem(
          bulletinItem: _bulletinItem,
          numberOfComments: _numberOfComments,
        )
        );
        break;
      case "event":
        item = Card(
          child: BulletinEventItem(
          bulletinItem: _bulletinItem,
          numberOfComments: _numberOfComments,
        )
        );
        break;
      case "play":
        item = Card(
          child: BulletinPlayItem(
          bulletinItem: _bulletinItem,
          numberOfComments: _numberOfComments,
        )
        );
        break;
    }

    return item;
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
    LocalUserInfo _localuserInfo = await UserAuth.getLoclUserInfo();
    item.authorId = _localuserInfo.id;
    item.authorName = _localuserInfo.name;
    item.authorPhotoUrl = _localuserInfo.photoUrl;
    item.creationDate = DateTime.now();
    item.id = _bulletinItem.id;
    await BulletinFirestore.saveCommentItem(item);
  }
}
