import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/circle_profile_image.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/ui/write_to/helpers/write_to_data.dart';

class WriteToRow extends StatelessWidget {
  final WriteToData item;
  final ValueChanged<WriteToData> onRowTap;
  final ValueChanged<WriteToData> onSettingPressed;
  final bool showStatusIcons;
  final bool showSettings;

  const WriteToRow(
      {Key key,
      @required this.item,
      this.onRowTap,
      this.onSettingPressed,
      this.showSettings = false,
      this.showStatusIcons = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      onTap: () {
        onRowTap(item);
      },
      title: Column(
        children: <Widget>[_title(), _titleStatusIcons(context)],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(item.message),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.access_time, size: 12.0),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(DateTimeHelpers.ddMMyyyyHHnn(
                      context, item.createdDate.toDate())),
                )
              ],
            ),
          )
        ],
      ),
    ));
  }

  Widget _title() {
    Widget value = Container();

    switch (item.type) {
      case "mail":
        value = _titleText(item.sendToEmail);
        break;
      case "message":
        value = _titleText(item.sendToName);
        break;
      case "public":
        value = _titleText(item.fromName);
        break;
      case "reply":
        value = _titleText(item.fromName);
        break;
      case "reply_locale":
        value = _titleText(item.fromName);
        break;
    }

    return value;
  }

  Widget _titleText(String text) {
    List<Widget> titleRow = [];
    if (item.fromPhotoUrl != null && item.fromPhotoUrl.isNotEmpty) {
      titleRow.add(Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: CircleProfileImage(
          url: item.fromPhotoUrl,
        ),
      ));
    }
    
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

  Widget _titleStatusIcons(BuildContext context) {
    final double fontSize = 14.0;
    Widget value = Container();
    if (showStatusIcons) {
      if (item.type == "mail") {
        return Tooltip(
          message: FlutterI18n.translate(context, "writeTo.writeToRow.string1"),
          child: Row(
            children: <Widget>[
              Icon(Icons.arrow_forward, size: fontSize, color: Colors.blueGrey),
              Icon(Icons.mail, size: fontSize, color: Colors.blueGrey)
            ],
          ),
        );
      }

      if (item.type == "message") {
        return Tooltip(
          message: FlutterI18n.translate(context, "writeTo.writeToRow.string2"),
          child: Row(
            children: <Widget>[
              Icon(Icons.arrow_forward, size: fontSize, color: Colors.blueGrey),
              Icon(Icons.message, size: fontSize, color: Colors.blueGrey)
            ],
          ),
        );
      }

      if (item.type == "public") {
        return Tooltip(
          message: FlutterI18n.translate(context, "writeTo.writeToRow.string3"),
          child: Row(
            children: <Widget>[
              Icon(Icons.arrow_back, size: fontSize, color: Colors.blueGrey),
              Icon(Icons.person, size: fontSize, color: Colors.blueGrey)
            ],
          ),
        );
      }
    }

    return value;
  }
}
