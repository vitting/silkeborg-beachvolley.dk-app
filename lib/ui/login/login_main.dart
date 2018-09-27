import "package:flutter/material.dart";
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'auth_functions.dart' as authFunctions;

class Login extends StatefulWidget {
  static final routeName = "/login";
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoggedIn;
  // bool _saving = false;
  
  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        title: "Silkeborg Beachvolley", 
        body: _main(context)
        );
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
              await authFunctions.signInWithFacebook();
              Navigator.of(context).pushNamedAndRemoveUntil("/", ((Route<dynamic> route) => false));
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
}
