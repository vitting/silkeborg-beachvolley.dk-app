import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/notification_data.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_widget.dart';
import 'package:silkeborgbeachvolley/ui/helpers/no_data_widget.dart';
import 'package:silkeborgbeachvolley/ui/main_inheretedwidget.dart';
import 'package:silkeborgbeachvolley/ui/notifications/helpers/notifications_data.dart';
import 'package:silkeborgbeachvolley/ui/notifications/helpers/notifications_row_widget.dart';
import 'package:silkeborgbeachvolley/ui/write_to/admin/admin_write_to_main.dart';
import 'package:silkeborgbeachvolley/ui/write_to/write_to_main.dart';

class NotiticationButton extends StatefulWidget {
  final ValueChanged<int> onBulletinSelected;

  const NotiticationButton({Key key, this.onBulletinSelected})
      : super(key: key);
  @override
  NotiticationButtonState createState() {
    return new NotiticationButtonState();
  }
}

class NotiticationButtonState extends State<NotiticationButton> {
  final Color notificationColor = Colors.white;
  bool showNewNotificationIndicator = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    MainInherited.of(context, false)
        .notificationsAsStream
        .listen((NotificationData value) {
      if (value.type == "bulletin" || value.type == "writeto") {
        setState(() {
          showNewNotificationIndicator = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        IconButton(
          color: notificationColor,
          tooltip: FlutterI18n.translate(
              context, "notifications.notificationButtonWidget.string1"),
          icon: Icon(Icons.notifications),
          onPressed: () async {
            NotificationsData notification = await _showNotifications(context);
            if (notification != null) {
              _handleNotification(context, notification);

              if (showNewNotificationIndicator) {
                setState(() {
                  showNewNotificationIndicator = false;
                });
              }
            }
          },
        ),
        showNewNotificationIndicator
            ? Positioned(
                top: 26.0,
                left: 6.0,
                right: 0.0,
                child: Container(
                  height: 10.0,
                  decoration:
                      BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                ),
              )
            : Container()
      ],
    );
  }

  Future<NotificationsData> _showNotifications(BuildContext context) async {
    return showDialog<NotificationsData>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => Dialog(
                child: StreamBuilder(
              stream: NotificationsData.getUserNotificationsAsStream(
                  MainInherited.of(context).userId),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return LoaderSpinner();
                if (snapshot.hasData && snapshot.data.documents.length == 0)
                  return NoData(FlutterI18n.translate(context,
                      "notifications.notificationButtonWidget.string2"));

                return Container(
                    padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),
                    child: _buildListOfNotifications(snapshot.data));
              },
            )));
  }

  Widget _buildListOfNotifications(QuerySnapshot snapshot) {
    return Scrollbar(
          child: ListView.builder(
        itemCount: snapshot.documents.length,
        itemBuilder: (BuildContext context, int position) {
          print("LENGHT: ${snapshot.documents.length} / POSITION: $position");
          if (snapshot.documents.length -1 == position) {
            print("THIS IS THE LAST ONE");
          }
          DocumentSnapshot docSnapshot = snapshot.documents[position];
          NotificationsData item = NotificationsData.fromMap(docSnapshot.data, docSnapshot.documentID);

          return NotificationsRow(
              item: item,
              onTap: (NotificationsData selected) {
                Navigator.of(context).pop(selected);
              });
        },
      ),
    );
  }

  void _handleNotification(
      BuildContext context, NotificationsData notification) {
    if (notification.type == "bulletin") {
      int bottomBarSelected = 0;
      switch (notification.subType) {
        case "news":
          bottomBarSelected = 0;
          break;
        case "event":
          bottomBarSelected = 1;
          break;
        case "play":
          bottomBarSelected = 2;
          break;
      }

      if (widget.onBulletinSelected != null) {
        widget.onBulletinSelected(bottomBarSelected);
      }
    }

    if (notification.type == "writeto") {
      if (notification.subType == "message_from_public" ||
          notification.subType == "message_reply_from_public") {
        Navigator.of(context).push(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (BuildContext context) => AdminWriteTo()));
      }

      if (notification.subType == "message_from_sbv" ||
          notification.subType == "message_reply_from_sbv") {
        Navigator.of(context).push(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (BuildContext context) => WriteTo()));
      }
      print(notification.subType);
    }
  }
}
