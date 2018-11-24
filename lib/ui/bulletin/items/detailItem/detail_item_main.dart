import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/dialogs_class.dart';
import 'package:silkeborgbeachvolley/ui/main_inheretedwidget.dart';
import 'package:silkeborgbeachvolley/ui/helpers/list_item_card_widget.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_widget.dart';
import 'package:silkeborgbeachvolley/helpers/system_helpers.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/detailItem/bulletin_comment_item_data.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_item_data.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/detailItem/bulletin_comment_item_row_widget.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/eventItem/event_item.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/newsItem/news_item.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/playItem/play_item.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

class BulletinDetailItem extends StatefulWidget {
  final BulletinItemData bulletinItem;
  const BulletinDetailItem(this.bulletinItem);

  @override
  _BulletinDetailItemState createState() => _BulletinDetailItemState();
}

class _BulletinDetailItemState extends State<BulletinDetailItem> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  final _defaultNumberOfItemsToLoad = 50;
  int _numberOfItemsToLoad;
  int _currentLengthOfLoadedItems = 0;

  @override
  void initState() {
    super.initState();
    _numberOfItemsToLoad = _defaultNumberOfItemsToLoad;
    _scrollController.addListener(_handleScrollLoadMore);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        title: FlutterI18n.translate(context, "bulletin.detailItemMain.title"),
        body: _main(context));
  }

  Widget _main(BuildContext context) {
    return ListView(
      primary: false,
      controller: _scrollController,
      children: <Widget>[
        _createBulletinMainItem(),
        _addComment(context),
        StreamBuilder(
          stream: widget.bulletinItem.getCommentsAsStream(_numberOfItemsToLoad),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              print("ERROR detail_item_main StreamBuilder: ${snapshot.error}");
              return Container();
            }

            if (!snapshot.hasData) return LoaderSpinner();

            widget.bulletinItem.numberOfcomments =
                snapshot.data.documents.length;
            _currentLengthOfLoadedItems = snapshot.data.documents.length;

            return ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int position) {
                BulletinCommentItemData item = BulletinCommentItemData.fromMap(
                    snapshot.data.documents[position].data);
                return ListItemCard(
                  child: BulletinCommentItemRow(
                    bulletinItem: item,
                    onTapMenu: (ConfirmDialogAction action) async {
                      if (action == ConfirmDialogAction.delete) {
                        await item.delete();

                        ///Get comment counter updated
                        setState(() {});
                      }
                    },
                  ),
                );
              },
            );
          },
        )
      ],
    );
  }

  Widget _createBulletinMainItem() {
    var item;
    switch (widget.bulletinItem.type) {
      case BulletinType.news:
        item = BulletinNewsItem(
          bulletinItem: widget.bulletinItem,
          isDetailMode: true,
        );
        break;
      case BulletinType.event:
        item = BulletinEventItem(
          bulletinItem: widget.bulletinItem,
          isDetailMode: true,
        );
        break;
      case BulletinType.play:
        item = BulletinPlayItem(
          bulletinItem: widget.bulletinItem,
          isDetailMode: true,
        );
        break;
      case BulletinType.none:
        break;
    }

    return Card(child: item);
  }

  Widget _addComment(BuildContext context) {
    BulletinCommentItemData bulletinCommentItem =
        new BulletinCommentItemData(bulletinId: widget.bulletinItem.id);
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
                if (value.isEmpty)
                  return FlutterI18n.translate(
                      context, "bulletin.detailItemMain.string1");
              },
              decoration: InputDecoration(
                  labelText: FlutterI18n.translate(
                      context, "bulletin.detailItemMain.string2"),
                  suffixIcon: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          _formKey.currentState.reset();
                          await _saveBulletinCommentItem(
                              MainInherited.of(context).loggedInUser,
                              bulletinCommentItem);
                          SystemHelpers.hideKeyboardWithNoFocus(context);
                        }
                      })),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveBulletinCommentItem(
      FirebaseUser user, BulletinCommentItemData item) async {
    await item.save(user);
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
