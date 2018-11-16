import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/circle_profile_image.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/ui/write_to/helpers/write_to_data.dart';

class WriteToRow extends StatelessWidget {
  final WriteToData item;
  final ValueChanged<WriteToData> onRowTap;
  final ValueChanged<WriteToData> onSettingPressed;
  final bool showSettings;
  final bool isAdmin;
  final bool isDetail;

  const WriteToRow(
      {Key key,
      @required this.item,
      this.onRowTap,
      this.onSettingPressed,
      this.isAdmin = false,
      this.isDetail = false,
      this.showSettings = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      onTap: () {
        if (onRowTap != null) {
          onRowTap(item);
        }
      },
      title: _title(),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(item.message),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: _infoRow(context))
        ],
      ),
    ));
  }

  Widget _infoRow(BuildContext context) {
    Widget value;
    if (isAdmin) {
      /// Admin Recieved messages
      if (item.type == "public") {
        if (item.subType == "message") {
          value = Tooltip(
            message:
                FlutterI18n.translate(context, "writeTo.writeToRow.string2"),
            child: Row(
              children: <Widget>[
                Icon(Icons.arrow_forward, size: 12.0, color: Colors.blueGrey),
                Icon(Icons.message, size: 12.0, color: Colors.blueGrey)
              ],
            ),
          );
        }

        if (item.subType == "mail") {
          value = Tooltip(
            message:
                FlutterI18n.translate(context, "writeTo.writeToRow.string3"),
            child: Row(
              children: <Widget>[
                Icon(Icons.arrow_forward, size: 12.0, color: Colors.blueGrey),
                Icon(Icons.mail, size: 12.0, color: Colors.blueGrey)
              ],
            ),
          );
        }
      }

      /// Admin Sent messages and mails
      if (item.type == "admin") {
        /// Admin Sent messages
        if (item.subType == "message") {
          value = Tooltip(
            message:
                FlutterI18n.translate(context, "writeTo.writeToRow.string1"),
            child: Row(
              children: <Widget>[
                Icon(Icons.arrow_back, size: 12.0, color: Colors.blueGrey),
                Icon(Icons.message, size: 12.0, color: Colors.blueGrey)
              ],
            ),
          );
        }

        /// Admin Sent mails
        if (item.subType == "mail") {}
      }
    } else {
      if (item.type == "public" && item.subType == "message") {
        /// User Sent message
        value = Tooltip(
          message: FlutterI18n.translate(context, "writeTo.writeToRow.string1"),
          child: Row(
            children: <Widget>[
              Icon(Icons.arrow_back, size: 12.0, color: Colors.blueGrey),
              Icon(Icons.message, size: 12.0, color: Colors.blueGrey)
            ],
          ),
        );
      }

      if (item.type == "admin" && item.subType == "message") {
        /// User received message
        value = Tooltip(
          message: FlutterI18n.translate(context, "writeTo.writeToRow.string2"),
          child: Row(
            children: <Widget>[
              Icon(Icons.arrow_forward, size: 12.0, color: Colors.blueGrey),
              Icon(Icons.message, size: 12.0, color: Colors.blueGrey)
            ],
          ),
        );
      }
    }

    return Row(
      children: <Widget>[
        isDetail
            ? Container()
            : Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: value,
              ),
        Icon(Icons.access_time, size: 12.0, color: Colors.blueGrey),
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Text(
              DateTimeHelpers.ddMMyyyyHHnn(context, item.createdDate.toDate()),
              style: TextStyle(color: Colors.blueGrey)),
        )
      ],
    );
  }

  Widget _title() {
    Widget value = Container();

    /// Admin
    if (isAdmin) {
      if (item.type == "public") {
        /// Admin Recieved message from user logged in
        if (item.subType == "message") {
          value = _titleText(item.fromName, item.fromPhotoUrl);
        }

        /// Admin Recieved message from user not logged in
        if (item.subType == "mail") {
          value = _titleText(item.fromName, item.fromPhotoUrl);
        }

        if (item.subType == "reply") {
          value = _titleText(item.fromName, item.fromPhotoUrl);
        }
      }

      /// Admin Sent messages and mails
      if (item.type == "admin") {
        /// Admin Sent messages
        if (item.subType == "message") {
          value = _titleText(item.sendToName, item.sendToPhotoUrl);
        }

        /// Admin Sent mails
        if (item.subType == "mail") {
          value = _titleText(item.sendToEmail, item.sendToPhotoUrl);
        }

        /// Admin replies message
        if (item.subType == "reply_message") {
          value = _titleText(item.fromName, item.fromPhotoUrl);
        }

        /// Admin replies email
        if (item.subType == "reply_mail") {
          value = _titleText(item.fromName, item.fromPhotoUrl);
        }
      }
    } else {
      /// User
      /// User Sent messages
      if (item.type == "public" && item.subType == "message") {
        value = _titleText(item.sendToName, item.sendToPhotoUrl);
      } else {
        /// User Recieved messages
        value = _titleText(item.fromName, item.fromPhotoUrl);
      }
    }

    return value;
  }

  Widget _titleText(String text, String photoUrl) {
    List<Widget> titleRow = [];
    titleRow.add(Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: CircleProfileImage(
        url: photoUrl,
      ),
    ));

    titleRow.add(Expanded(child: Text(text)));

    if (showSettings) {
      titleRow.add(IconButton(
        icon: Icon(Icons.more_horiz),
        onPressed: () {
          onSettingPressed(item);
        },
      ));
    }

    return Row(
      mainAxisAlignment: showSettings
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.start,
      children: titleRow,
    );
  }
}
