import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:silkeborgbeachvolley/helpers/userauth.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoggedIn;
  @override
    void initState() {
      // TODO: implement initState
      super.initState();
    }
  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        title: "Silkeborg Beachvolley", 
        body: _main(context)
        );
  }

  Widget _main(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 70.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              _signInWithGoogle(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(Icons.extension),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text("Log ind med Google"),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          RaisedButton(
            onPressed: () {
              _signInWithFacebook(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(Icons.face),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text("Log ind med Facebook"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _signInWithGoogle(BuildContext context) async {
    final FirebaseUser user = await UserAuth.signInWithGoogle();
    await UserAuth.setLoginProvider("google");
    Navigator.pushNamedAndRemoveUntil(context, "/", ((Route<dynamic> route) => false));
  }

  void _signInWithFacebook(BuildContext context) async {
    final FirebaseUser user = await UserAuth.signInWithFacebook();
    await UserAuth.setLoginProvider("facebook");
    Navigator.pushNamedAndRemoveUntil(context, "/", ((Route<dynamic> route) => false));
  }
}
