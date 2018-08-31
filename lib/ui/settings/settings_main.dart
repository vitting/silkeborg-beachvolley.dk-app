import 'dart:async';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/userauth.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context)  {

    return SilkeborgBeachvolleyScaffold(
        title: "Silkeborg Beachvolley",
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 70.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FutureBuilder<Widget>(
                future: _getLogoutButton(context),
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

  Future<Widget> _getLogoutButton(BuildContext context) async {
      String loginProvider = await UserAuth.getLoginProvider();
      switch(loginProvider) {
      case "google":
        return _googleLogoutButton(context);
      case "facebook":
        return _facebookLogoutButton(context);
      default:
        return null;
    }
  }

  Widget _googleLogoutButton(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        UserAuth.signOutWithGoogle().then((value) async {
          await UserAuth.setLoginProvider(null);
          Navigator.pop(context, value);
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(Icons.extension),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text("Log ud med Google"),
          )
        ],
      ),
    );
  }

//Vi går tilbage til Home, men initState kører ikke da siden allerede er generet.
  Widget _facebookLogoutButton(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        UserAuth.signOutWithFacebook().then((value) async {
          await UserAuth.setLoginProvider(null);
          Navigator.of(context).pop();
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(Icons.face),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text("Log ud med Facebook"),
          )
        ],
      ),
    );
  }
}
