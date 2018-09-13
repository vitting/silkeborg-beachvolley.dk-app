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
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 45.0), 
            child: Text("Velkommen til silkeborg beachvolley og en masse andet tekst og sikkert også en indmeldelses formular.", textAlign: TextAlign.center, style: TextStyle(
              fontSize: 15.0
            ),),
          ),
          RaisedButton(
            color: Color(0xFF4267B2),
            padding: EdgeInsets.all(10.0),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/images/flogo-HexRBG-Wht-100.png",
                  height: 40.0
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Log ind med Facebook",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
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
    Navigator.pushNamedAndRemoveUntil(
        context, "/", ((Route<dynamic> route) => false));
  }
}
