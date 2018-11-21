import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/notification_data.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_widget.dart';
import 'package:silkeborgbeachvolley/ui/helpers/no_data_widget.dart';
import 'package:silkeborgbeachvolley/ui/main_inheretedwidget.dart';
import 'package:silkeborgbeachvolley/ui/notifications/helpers/notifications_data.dart';
import 'package:silkeborgbeachvolley/ui/notifications/helpers/notifications_row_widget.dart';

class NotiticationButton extends StatefulWidget {
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
          tooltip: "Notifikationer",
          icon: Icon(Icons.notifications),
          onPressed: () async {
            int result = await showDialog<int>(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) => Dialog(
                        child: FutureBuilder(
                      future: NotificationsData.getUserNotifications(
                          MainInherited.of(context).userId),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) return LoaderSpinner();
                        if (snapshot.hasData &&
                            snapshot.data.documents.length == 0)
                          return NoData("Der er ingen nye notificationer");

                        return ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (BuildContext context, int position) {
                            DocumentSnapshot docSnapshot =
                                snapshot.data.documents[position];
                            NotificationsData item = NotificationsData.fromMap(
                                docSnapshot.data, docSnapshot.documentID);

                            return NotificationsRow(
                                item: item,
                                onTap: (NotificationsData selected) {
                                  print(selected);
                                });
                          },
                        );
                      },
                    )));

            setState(() {
              showNewNotificationIndicator = false;
            });
          },
        ),
        showNewNotificationIndicator ? Positioned(
          top: 20.0,
          left: 0.0,
          right: 0.0,
          child: Container(
            height: 10.0,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle
            ),
          ),
        ) : Container()
      ],
    );
  }
}
