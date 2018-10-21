import "package:flutter/material.dart";
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/main/enrollment_main.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'helpers/auth_functions.dart' as authFunctions;

class Login extends StatelessWidget {
  static final routeName = "/login";
  final ValueChanged<bool> onLogIn;

  const Login({Key key, this.onLogIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        showAppBar: false, body: _main(context));
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
      )),
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 70.0),
            child: Text(FlutterI18n.translate(context, "login.loginMain.string1"),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18.0)),
          ),
          Image.asset("assets/images/logo_white_250x250.png",
              width: 100.0, height: 100.0),
          Container(
            width: 250.0,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              color: Color(0xFF4267B2),
              padding: EdgeInsets.all(10.0),
              onPressed: () async {
                await authFunctions.signInWithFacebook();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset("assets/images/flogo-HexRBG-Wht-100.png",
                      height: 30.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      FlutterI18n.translate(context, "login.loginMain.string2"),
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
              FlutterI18n.translate(context, "login.loginMain.string3"),
              style: TextStyle(color: Colors.white, fontSize: 12.0),
              textAlign: TextAlign.center),
          Text(
              FlutterI18n.translate(context, "login.loginMain.string4"),
              style: TextStyle(color: Colors.white, fontSize: 12.0),
              textAlign: TextAlign.center),
          FlatButton.icon(
            onPressed: () {
              Navigator.of(context).pushNamed(Enrollment.routeName);
            },
            label: Text(
              FlutterI18n.translate(context, "login.loginMain.string5"),
              style: TextStyle(color: Colors.white),
            ),
            icon: Icon(
              Icons.people,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
