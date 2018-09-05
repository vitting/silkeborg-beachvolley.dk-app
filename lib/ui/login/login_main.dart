import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:silkeborgbeachvolley/helpers/user_firestore.dart';
import 'package:silkeborgbeachvolley/helpers/userauth.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Login extends StatefulWidget {
  static final routeName = "/login";
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoggedIn;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        title: "Silkeborg Beachvolley", 
        body: ModalProgressHUD(
          child: _main(context),
          inAsyncCall: _saving,
          opacity: 0.5,
        ));
  }

  Widget _main(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 70.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            onPressed: () async {
              setState(() {
                _saving = true;                
              });
              await _signInWithGoogle(context);
              setState(() {
                _saving = false;                
              });
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
            onPressed: () async {
              setState(() {
                _saving = true;                
              });
              await _signInWithFacebook(context);
              setState(() {
                _saving = false;                
              });
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

  Future<void> _signInWithGoogle(BuildContext context) async {
    setState(() {
      _saving = true;                
    });
    final FirebaseUser user = await UserAuth.signInWithGoogle();
    if (user != null) _finalSignInTasks(context, user, "google");
    setState(() {
      _saving = false;                
    });
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    setState(() {
      _saving = true;                
    });
    final FirebaseUser user = await UserAuth.signInWithFacebook();
    if (user != null) _finalSignInTasks(context, user, "facebook");
    setState(() {
      _saving = false;                
    });
  }

  Future<void> _finalSignInTasks(BuildContext context, FirebaseUser user, String loginProvider) async {
    await UserFirestore.setUserInfo(user);
    await UserAuth.setLocalUserInfo(user);
    await UserAuth.setLoginProvider("facebook");
    Navigator.pushNamedAndRemoveUntil(
        context, "/", ((Route<dynamic> route) => false));
  }
}
