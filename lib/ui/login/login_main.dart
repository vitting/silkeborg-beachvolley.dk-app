import "package:flutter/material.dart";
import 'package:silkeborgbeachvolley/ui/enrollment/enrollment_main.dart';
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
      showAppBar: false,
        body: _main(context)
        );
  }

  Widget _main(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
           begin: Alignment.topLeft,
            end: Alignment.bottomRight, 
            stops: [0.1, 0.5, 0.7, 0.9],
            colors: [
              Colors.blue[300],
              Colors.blue[500],
              Colors.blue[700],
              Colors.blue[900],
            ],
        )
      ),
      padding: EdgeInsets.only(left: 30.0, right: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 70.0, bottom: 5.0), 
            child: Text("Velkommen til", textAlign: TextAlign.center, style: TextStyle(
              color: Colors.white,
              fontSize: 20.0
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0), 
            child: Text("Silkeborg Beachvolley", textAlign: TextAlign.center, style: TextStyle(
              color: Colors.white,
              fontSize: 20.0
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Image.asset("assets/images/logo_white_250x250.png", width: 150.0, height: 150.0),
          ),
          
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)
            ),
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
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Text(
                    "Log ind med Facebook",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text("Det med småt", style: TextStyle(color: Colors.white)),
          FlatButton.icon(
            onPressed: () {
              Navigator.of(context).pushNamed(Enrollment.routeName);
            },
            label: Text("Indmeldelse i Silkeborg Beachvolley", style: TextStyle(color: Colors.white),),
            icon: Icon(Icons.people, color: Colors.white,),
          )
        ],
      ),
    );
  }
}
