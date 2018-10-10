import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_commit_button_widget.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_title_widget.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/playItem/play_item_data_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/item_datetime_numberofcomments.dart';
import '../../helpers/bulletin_commit_functions.dart' as committedFunctions;

enum PlayerCommitStatus { commit, uncommit }

class BulletinPlayItem extends StatefulWidget {
  final BulletinPlayItemData bulletinItem;
  final Function onTap;
  final Function onPressed;
  final int maxLines;
  final TextOverflow overflow;
  final bool isDetailMode;

  BulletinPlayItem(
      {this.bulletinItem,
      this.onTap,
      this.onPressed,
      this.maxLines = 3,
      this.overflow = TextOverflow.ellipsis,
      this.isDetailMode = false});

  @override
  BulletinPlayItemState createState() {
    return new BulletinPlayItemState();
  }
}

class BulletinPlayItemState extends State<BulletinPlayItem> {
  ButtonState _isCommitted;
  
  @override
  void initState() {
    super.initState();
    _initCommitted();
  }

  _initCommitted() async {
    if (widget.isDetailMode) {
      bool commited = await widget.bulletinItem.isCommitted();
      if (mounted) {
        setState(() {
          if (commited) {
            _isCommitted = ButtonState.remove;
          } else {
            _isCommitted = ButtonState.add;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      ListTile(
        title: BulletinTitle(
          name: widget.bulletinItem.authorName,
          userId: widget.bulletinItem.authorId,
          photoUrl: widget.bulletinItem.authorPhotoUrl,
          onPressed: widget.onPressed,
          isDetailMode: widget.isDetailMode,
          showImage: true,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(widget.bulletinItem.body,
                  maxLines: widget.maxLines, overflow: widget.overflow),
            ),
            DateTimeNumberOfCommentsAndCommits(
              bulletinItem: widget.bulletinItem,
              numberOfCommits:
                  widget.bulletinItem.numberOfCommits,
              onTapPlayerCount: () {
                committedFunctions.showCommittedDialog(context, widget.bulletinItem);
              },
            ),
          ],
        ),
        trailing: widget.isDetailMode ? ConfirmButton(
          buttonState: _isCommitted,
          onPress: (ButtonState state) {
            _onPressedCommit(state);
          },
        ) : null,
        onTap: widget.onTap,
      )
    ];

    return ListBody(children: widgets);
  }

  _onPressedCommit(ButtonState state) async {
    ButtonState newState;
    if (state == ButtonState.add) {
      widget.bulletinItem.setAsCommitted();
      widget.bulletinItem.numberOfCommits++;
      newState = ButtonState.remove;
    } else {
      widget.bulletinItem.setAsUnCommitted();
      widget.bulletinItem.numberOfCommits--;
      newState = ButtonState.add;
    }
    
    if (mounted) {
      setState(() {
        _isCommitted = newState;
      });
    }
  }
}
