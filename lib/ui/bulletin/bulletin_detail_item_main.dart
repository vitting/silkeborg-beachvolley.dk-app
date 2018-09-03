import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/bulletin_comment_item_class.dart';
import 'package:silkeborgbeachvolley/helpers/bulletin_firestore.dart';
import 'package:silkeborgbeachvolley/helpers/bulletin_item_class.dart';
import 'package:silkeborgbeachvolley/helpers/local_user_info_class.dart';
import 'package:silkeborgbeachvolley/helpers/userauth.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

class BulletinDetailItem extends StatefulWidget {
  final BulletinItem bulletinItem;
  BulletinDetailItem(this.bulletinItem);

  @override
  _BulletinDetailItemState createState() => _BulletinDetailItemState();
}

class _BulletinDetailItemState extends State<BulletinDetailItem> {
  final ScrollController _listScrollController = ScrollController();
  int _numberOfComments = 0;
  BulletinItem _bulletinItem;
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
      padding: EdgeInsets.all(10.0),
      children: <Widget>[
        _firstItem(),
        StreamBuilder(
          stream: BulletinFirestore.getAllBulletinComments(_bulletinItem.id),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return Text('Henter data...');
            if (snapshot.hasData) _numberOfComments = snapshot.data.documents.length;
            return Column(
                children: snapshot.data.documents
                    .map<Widget>((DocumentSnapshot document) {
              return _commentItem(document.data);
            }).toList());
          },
        )
      ],
    );
  }

  Widget _firstItem() {
    return ListBody(
      children: <Widget>[
        ListTile(
          title: _nameDateNumberOfComments(),
          leading: CircleAvatar(
              backgroundImage: NetworkImage(_bulletinItem.authorPhotoUrl)),
          subtitle: Text(_bulletinItem.body),
        ),
        _addComment()
      ],
    );
  }

  _nameDateNumberOfComments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(_bulletinItem.authorName),
        Row(
          children: <Widget>[
            Icon(Icons.access_time, size: 10.0),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text(
                _bulletinItem.creationDateFormatted,
                style: TextStyle(fontSize: 10.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 5.0),
              child: Icon(Icons.chat_bubble_outline, size: 10.0),
            ),
            Text(_numberOfComments.toString(),
                style: TextStyle(fontSize: 10.0))
          ],
        )
      ],
    );
  }

  Widget _addComment() {
    TextEditingController newCommentController = new TextEditingController();

    return ListBody(
      children: <Widget>[
        TextField(
          controller: newCommentController,
          decoration: InputDecoration(
              labelText: "Skriv en kommentar",
              suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (newCommentController.text.isNotEmpty) {
                      BulletinCommentItem bulletinCommentItem =
                          new BulletinCommentItem(
                              body: newCommentController.text);

                      _saveBulletinCommentItem(bulletinCommentItem);
                    }

                    newCommentController.clear();
                  })),
        )
      ],
    );
  }

  Widget _commentItem(Map<String, dynamic> item) {
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
