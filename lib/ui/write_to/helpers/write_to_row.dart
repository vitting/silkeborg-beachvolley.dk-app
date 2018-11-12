import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/circle_profile_image.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/ui/write_to/helpers/write_to_data.dart';

class WriteToRow extends StatelessWidget {
  final WriteToData item;
  final ValueChanged<WriteToData> onRowTap;
  final ValueChanged<WriteToData> onSettingPressed;
  final bool showSettings;
  final bool isAdmin;

  const WriteToRow(
      {Key key,
      @required this.item,
      this.onRowTap,
      this.onSettingPressed,
      this.isAdmin = false,
      this.showSettings = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      onTap: () {
        onRowTap(item);
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
        value =
            isAdmin ? _titleText(item.sendToName) : _titleText(item.fromName);
        break;
      case "public":
        value =
            isAdmin ? _titleText(item.fromName) : _titleText(item.sendToName);
        break;
      case "reply":
        value = _titleText(item.fromName);
        break;
      case "reply_locale":
        value = _titleText(item.fromName);
        break;
      case "reply_locale_mail":
        value = _titleText(item.fromName);
        break;
    }

    return value;
  }

  Widget _titleText(String text) {
    List<Widget> titleRow = [];
    if (isAdmin) {
      if (item.type == "public") {
        titleRow.add(Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: CircleProfileImage(
            url: item.fromPhotoUrl,
          ),
        ));
      }

      if (item.type == "message" || item.type == "mail") {
        titleRow.add(Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: CircleProfileImage(
            url: item.sendToPhotoUrl,
          ),
        ));
      }
    } else {
      if (item.type == "public") {
        titleRow.add(Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: CircleProfileImage(
            url: item.sendToPhotoUrl,
          ),
        ));
      } else {
        titleRow.add(Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: CircleProfileImage(
            url: item.fromPhotoUrl,
          ),
        ));
      }
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
}
