import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/confirm_dialog_action_enum.dart';
import 'package:silkeborgbeachvolley/helpers/list_item_card_widget.dart';
import 'package:silkeborgbeachvolley/helpers/loader_spinner_widget.dart';
import 'package:silkeborgbeachvolley/helpers/system_helpers_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/detailItem/bulletin_comment_item_data.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/item_data_class.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        title: "Silkeborg Beachvolley", body: _main());
  }

  Widget _main() {
    return ListView(
      children: <Widget>[
        _createBulletinMainItem(),
        _addComment(),
        StreamBuilder(
          stream: widget.bulletinItem.getCommentsAsStream(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return LoaderSpinner();
            widget.bulletinItem.numberOfcomments =
                snapshot.data.documents.length;
            return Column(
                children:
                    snapshot.data.documents.map<Widget>((DocumentSnapshot doc) {
              BulletinCommentItemData item =
                  BulletinCommentItemData.fromMap(doc.data);
              return ListItemCard(
                child: BulletinCommentItemRow(
                  bulletinItem: item,
                  onTapMenu: (ConfirmDialogAction action) async {
                    if (action == ConfirmDialogAction.delete) {
                      await item.delete();

                      ///Get comment counter updated
                      if (mounted) {
                        setState(() {});
                      }
                    }
                  },
                ),
              );
            }).toList());
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

  Widget _addComment() {
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
                if (value.isEmpty) return "Skal udfyldes";
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

  Future<void> _saveBulletinCommentItem(BulletinCommentItemData item) async {
    await item.save();
  }
}
