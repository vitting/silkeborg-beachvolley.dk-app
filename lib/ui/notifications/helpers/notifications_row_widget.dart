import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/circle_profile_image.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/ui/notifications/helpers/notifications_data.dart';

class NotificationsRow extends StatelessWidget {
  final NotificationsData item;
  final ValueChanged<NotificationsData> onTap;

  const NotificationsRow({Key key, @required this.item, @required this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTap(item);
      },
      leading: CircleProfileImage(
        url: item.fromDisplayUrl,
      ),
      title: Text("${item.fromName} ${_getTitleMessage()}"),
      subtitle: Text(
          DateTimeHelpers.ddMMyyyyHHnn(context, item.creationDate.toDate())),
    );
  }

  String _getTitleMessage() {
    String message = "";
    if (item.type == "writeto") {
      switch (item.subType) {
        case "message_from_public":
          message = "har sendt en besked til SBV";
          break;
        case "message_from_sbv":
          message = "har sendt dig en besked";
          break;
        case "message_reply_from_public":
          message = "har svaret på en besked fra SBV";
          break;
        case "message_reply_from_sbv":
          message = "har svaret på din besked";
          break;
        default:
      }
    }

    if (item.type == "bulletin") {
      switch (item.subType) {
        case "news":
          message = "har oprettet en nyhed";
          break;
        case "event":
          message = "har oprettet en begivenhed";
          break;
        case "play":
          message = "har oprettet spil";
          break;
      }
    }

    return message;
  }
}