import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/ui/main_inheretedwidget.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_commit_button_widget.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_item_image_viewer_widget.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_item_pictures_widget.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_title_widget.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/image_type_enum.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/eventItem/event_item_data.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/item_datetime_numberofcomments.dart';
import '../../helpers/bulletin_commit_functions.dart' as committedFunctions;

class BulletinEventItem extends StatefulWidget {
  final BulletinEventItemData bulletinItem;
  final Function onTap;
  final Function onPressed;
  final int maxLines;
  final TextOverflow overflow;
  final bool isDetailMode;

  const BulletinEventItem(
      {this.bulletinItem,
      this.onTap,
      this.onPressed,
      this.maxLines = 3,
      this.isDetailMode = false,
      this.overflow = TextOverflow.ellipsis});

  @override
  BulletinEventItemState createState() {
    return new BulletinEventItemState();
  }
}

class BulletinEventItemState extends State<BulletinEventItem> {
  ButtonState _isCommitted;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initCommitted(context);
  }

  _initCommitted(BuildContext context) async {
    if (widget.isDetailMode) {
      bool commited = await widget.bulletinItem
          .isCommitted(MainInherited.of(context).userId);
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
          isDetailMode: widget.isDetailMode,
          onPressed: widget.onPressed,
          photoUrl: widget.bulletinItem.authorPhotoUrl,
          showImage: true,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(widget.bulletinItem.eventTitle,
                        style: TextStyle(fontSize: 16.0, color: Colors.black)),
                  )
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Icon(
                  Icons.calendar_today,
                  size: 16.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(DateTimeHelpers.ddMMyyyy(
                      context, widget.bulletinItem.eventStartDate)),
                ),
                DateTimeHelpers.dateCompare(widget.bulletinItem.eventStartDate,
                        widget.bulletinItem.eventEndDate)
                    ? Container()
                    : Row(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text("-"),
                          ),
                          Text(DateTimeHelpers.ddMMyyyy(
                              context, widget.bulletinItem.eventEndDate))
                        ],
                      )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.alarm,
                    size: 16.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                        "Start: ${DateTimeHelpers.hhnn(widget.bulletinItem.eventStartTime)}"),
                  ),
                  Text(
                      "Slut: ${DateTimeHelpers.hhnn(widget.bulletinItem.eventEndTime)}")
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.place,
                    size: 16.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(widget.bulletinItem.eventLocation),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(widget.bulletinItem.body,
                  maxLines: widget.maxLines, overflow: widget.overflow),
            ),
            DateTimeNumberOfCommentsAndCommits(
              bulletinItem: widget.bulletinItem,
              numberOfCommits: widget.bulletinItem.numberOfCommits,
              onTapPlayerCount: () {
                committedFunctions.showCommittedDialog(
                    context, widget.bulletinItem);
              },
            ),
          ],
        ),
        onTap: widget.onTap,
        trailing: widget.isDetailMode
            ? ConfirmButton(
                buttonState: _isCommitted,
                onPress: (ButtonState state) {
                  _onPressedCommit(context, state);
                },
              )
            : null,
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: BulletinItemPictures(
          images: widget.bulletinItem.eventImage.link.isEmpty
              ? null
              : [widget.bulletinItem.eventImage.link],
          type: BulletinImageType.network,
          onTapImageSelected: widget.isDetailMode
              ? (String image) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          BulletinItemImageViewer(image),
                      fullscreenDialog: true));
                }
              : null,
        ),
      )
    ];

    return ListBody(children: widgets);
  }

  _onPressedCommit(BuildContext context, ButtonState state) async {
    ButtonState newState;
    if (state == ButtonState.add) {
      widget.bulletinItem
          .setAsCommitted(MainInherited.of(context).loggedInUser);
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
