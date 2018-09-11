import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/playItem/play_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/item_datetime_numberofcomments.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/playItem/player_committed_class.dart';

enum PlayerCommitStatus { commit, uncommit }


//CHRISTIAN: Maybe rewrite to statefull and remove commit features from detail item to save setstate and update comments.
class BulletinPlayItem extends StatelessWidget {
  final BulletinPlayItemData bulletinItem;
  final Function onTap;
  final Function onLongPress;
  final int maxLines;
  final TextOverflow overflow;
  final int numberOfComments;
  final int numberOfPlayersCommitted;
  final bool showCommitButtons;
  final bool isPlayerCommitted;
  final ValueChanged<PlayerCommitStatus> onPressedPlayerCommit;

  BulletinPlayItem(
      {this.bulletinItem,
      this.onTap,
      this.onLongPress,
      this.maxLines = 3,
      this.overflow = TextOverflow.ellipsis,
      this.numberOfComments = 0,
      this.showCommitButtons = false,
      this.isPlayerCommitted = false,
      this.numberOfPlayersCommitted = 0,
      this.onPressedPlayerCommit});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      ListTile(
        onLongPress: onLongPress,
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                  backgroundImage:
                      CachedNetworkImageProvider(bulletinItem.authorPhotoUrl)),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(bulletinItem.authorName),
              )
            ],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(bulletinItem.body,
                  maxLines: maxLines, overflow: overflow),
            ),
            DateTimeNumberOfCommentsAndPlayers(
                bulletinItem: bulletinItem,
                numberOfComments: numberOfComments,
                numberOfPlayersCommitted: numberOfPlayersCommitted,
                onTapPlayerCount: () {
                  _showPlayersCommittedDialog(context);                
                },
                ),
          ],
        ),
        trailing: _showPlayerCommittedButton(),
        onTap: onTap,
      )
    ];

    return ListBody(children: widgets);
  }

  Future<List> _buildPlayersCommittedDialogItems() async {
    List<PlayerCommitted> data = await bulletinItem.getPlayersCommitted();
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
        return SimpleDialog(
          title: Text("Spillere"),           
          children: widgets
        );
      }
    );
  }

  Widget _showPlayerCommittedButton() {
    if (showCommitButtons) {
      if (!isPlayerCommitted) {
        return Tooltip(
          message: "Ja jeg vil gerne spille",
          child: IconButton(
            icon: Icon(Icons.check_circle),
            color: Colors.greenAccent,
            iconSize: 40.0,
            onPressed: () {
              onPressedPlayerCommit(PlayerCommitStatus.commit);
            }),
        );
      } else {
        return Tooltip(
          message: "Fjern at jeg gerne vil spille",
          child: IconButton(
            icon: Icon(Icons.remove_circle),
            color: Colors.blueAccent,
            iconSize: 40.0,
            onPressed: () {
              onPressedPlayerCommit(PlayerCommitStatus.uncommit);
            }),
        );
      }
    } else {
      return null;
    }
  }
}
