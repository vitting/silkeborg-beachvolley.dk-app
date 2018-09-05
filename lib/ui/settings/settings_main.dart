import 'dart:async';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/userauth.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

class Settings extends StatelessWidget {
  static final routeName = "/settings";
  @override
  Widget build(BuildContext context)  {
    return SilkeborgBeachvolleyScaffold(
        title: "Silkeborg Beachvolley",
        body: Container(
          constraints: BoxConstraints.expand(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FutureBuilder<Widget>(
                future: _logoutButton(context),
                builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return snapshot.data;
                  }

                  return Container();
                },
              )
            ],
          ),
        ));
  }

  Future<Widget> _logoutButton(BuildContext context) async {
    String loginProvider = await UserAuth.getLoginProvider();

    return RaisedButton(
      onPressed: () async {
        bool value = loginProvider == "google" ? await UserAuth.signOutWithGoogle() : await UserAuth.signOutWithFacebook();
        UserAuth.setLoginProvider(null);
        Navigator.pop(context, value);
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
