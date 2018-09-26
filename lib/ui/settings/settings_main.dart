import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import '../login/auth_functions.dart' as authFunctions;

class Settings extends StatefulWidget {
  static final routeName = "/settings";

  @override
  SettingsState createState() {
    return new SettingsState();
  }
}

class SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        title: "Silkeborg Beachvolley",
        body: Container(
            constraints: BoxConstraints.expand(),
            child: ListView(
              children: <Widget>[
                Card(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        
                      ],
                    ),
                  ),
                ),
                _logoutButton(context)
              ],
            )));
  }

  Widget _logoutButton(BuildContext context) {
    return RaisedButton(
      onPressed: () async {
        await authFunctions.logout();
        Navigator.of(context).pop();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.extension),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text("Log ud"),
          )
        ],
      ),
    );
  }
}
