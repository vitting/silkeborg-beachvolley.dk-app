import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class TestWidget extends StatefulWidget {
  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  @override
    void initState() {
      super.initState();
      _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(
        alert: true,
        badge: true,
        sound: true
      ));
      _firebaseMessaging.configure(
        ///OnLaunch er der ikke body og titel med. Bliver executed når appen er termineret
        onLaunch: (Map<String, dynamic> message) {
          print("ONLAUNCH: $message");
        },
        ///OnMessage er der body og titel med. Bliver executed når appen er aktiv
        onMessage: (Map<String, dynamic> message) {
          print("ONMESSAGE: $message");
        },
        ///OnResume er der ikke body og titel med. Bliver executed når appen er minimeret
        onResume: (Map<String, dynamic> message) {
          print("ONRESUME: $message");
        }
      );

      _firebaseMessaging.getToken().then((String token) {
        print(token);
      });
    }
  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        title: "test",
        body: Container(
          child: Column(
            children: <Widget>[
              RaisedButton(
                onPressed: () async {
                  
                },
              )
            ],
          ),
        ));
  }
}
