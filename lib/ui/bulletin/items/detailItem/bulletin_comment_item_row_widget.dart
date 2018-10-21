import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/confirm_dialog_action_enum.dart';
import 'package:silkeborgbeachvolley/helpers/dialogs_class.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/items/detailItem/bulletin_comment_item_data.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';

class BulletinCommentItemRow extends StatelessWidget {
  final BulletinCommentItemData bulletinItem;
  final ValueChanged<ConfirmDialogAction> onTapMenu;

  const BulletinCommentItemRow({Key key, this.bulletinItem, this.onTapMenu})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(bulletinItem.authorName),
            Row(
              children: <Widget>[
                Icon(Icons.access_time, size: 10.0),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(bulletinItem.creationDateFormatted,
                      style: TextStyle(fontSize: 10.0)),
                )
              ],
            )
          ],
        ),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(bulletinItem.authorPhotoUrl),
        ),
        subtitle: Text(bulletinItem.body),
        trailing: _getButton(context, bulletinItem.authorId));
  }

  Widget _getButton(BuildContext context, String authorId) {
    Widget widgets;
    if (authorId == Home.loggedInUser.uid) {
      widgets = IconButton(
        icon: Icon(Icons.more_vert),
        onPressed: () async {
          ConfirmDialogAction action = ConfirmDialogAction.none;
          int resultModalBottomSheet = await Dialogs.modalBottomSheet(
              context, [DialogsModalBottomSheetItem(FlutterI18n.translate(context, "bulletin.bulletinCommentItemRowWidget.string1"), Icons.delete, 0)]);

          if (resultModalBottomSheet != null) {
            action = await Dialogs.confirmDelete(
                context, FlutterI18n.translate(context, "bulletin.bulletinCommentItemRowWidget.string2"));
          }

          onTapMenu(action);
        },
      );
    }

    return widgets;
  }
}
