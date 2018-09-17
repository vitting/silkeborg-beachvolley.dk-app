import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/playItem/play_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/item_datetime_numberofcomments.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/playItem/player_committed_class.dart';

enum PlayerCommitStatus { commit, uncommit }

//CHRISTIAN: Maybe rewrite to statefull and remove commit features from detail item to save setstate and update comments.
class BulletinPlayItem extends StatefulWidget {
  final BulletinPlayItemData bulletinItem;
  final Function onTap;
  final Function onLongPress;
  final int maxLines;
  final TextOverflow overflow;
  final bool showCommitButtons;

  BulletinPlayItem(
      {this.bulletinItem,
      this.onTap,
      this.onLongPress,
      this.maxLines = 3,
      this.overflow = TextOverflow.ellipsis,
      this.showCommitButtons = false});

  @override
  BulletinPlayItemState createState() {
    return new BulletinPlayItemState();
  }
}

class BulletinPlayItemState extends State<BulletinPlayItem> {
  bool _isPlayerCommitted = false;
  double _opacityLevel = 0.0;
  
  @override
  void initState() {
    super.initState();
    _initPlayerCommit();
  }

  _initPlayerCommit() async {
    bool playerCommmited = await widget.bulletinItem.isCommitted();

    setState(() {
      _isPlayerCommitted = playerCommmited;
      _opacityLevel = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      ListTile(
        onLongPress: widget.onLongPress,
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                      widget.bulletinItem.authorPhotoUrl)),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(widget.bulletinItem.authorName),
              )
            ],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(widget.bulletinItem.body,
                  maxLines: widget.maxLines, overflow: widget.overflow),
            ),
            DateTimeNumberOfCommentsAndPlayers(
              bulletinItem: widget.bulletinItem,
              numberOfPlayersCommitted:
                  widget.bulletinItem.numberOfPlayersCommitted,
              onTapPlayerCount: () {
                _showPlayersCommittedDialog(context);
              },
            ),
          ],
        ),
        trailing: _showPlayerCommittedButton(),
        onTap: widget.onTap,
      )
    ];

    return ListBody(children: widgets);
  }

  Future<List> _buildPlayersCommittedDialogItems() async {
    List<PlayerCommitted> data =
        await widget.bulletinItem.getPlayersCommitted();
    return data.map((PlayerCommitted player) {
      return ListTile(
        title: Text(player.name),
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(player.photoUrl),
        ),
      );
    }).toList();
  }

  _showPlayersCommittedDialog(BuildContext context) async {
    List widgets = await _buildPlayersCommittedDialogItems();

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(title: Text("Spillere"), children: widgets);
        });
  }

  _onPressedPlayerCommit(PlayerCommitStatus status) async {
    bool state = false;
    if (status == PlayerCommitStatus.commit) {
      widget.bulletinItem.setPlayerAsCommitted();
      // _numberOfPlayersCommitted++;
      state = true;
    } else {
      widget.bulletinItem.setPlayerAsUnCommitted();
      // _numberOfPlayersCommitted--;
    }

    setState(() {
      _isPlayerCommitted = state;
    });
  }

  Widget _showPlayerCommittedButton() {
    Widget widgets;
    if (!_isPlayerCommitted && widget.showCommitButtons) {
      widgets = Tooltip(
          message: "Ja jeg vil gerne spille",
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 500),
            opacity: _opacityLevel,
            child: IconButton(
                icon: Icon(Icons.check_circle),
                color: Colors.greenAccent,
                iconSize: 40.0,
                onPressed: () {
                  _onPressedPlayerCommit(PlayerCommitStatus.commit);
                  widget.bulletinItem.numberOfPlayersCommitted++;
                }),
          ));
    }

    if (_isPlayerCommitted && widget.showCommitButtons) {
      widgets = Tooltip(
          message: "Fjern at jeg gerne vil spille",
          child: AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: _opacityLevel,
              child: IconButton(
                  icon: Icon(Icons.remove_circle),
                  color: Colors.blueAccent,
                  iconSize: 40.0,
                  onPressed: () {
                    _onPressedPlayerCommit(PlayerCommitStatus.uncommit);
                    widget.bulletinItem.numberOfPlayersCommitted--;
                  })));
    }

    return widgets;
  }
}
