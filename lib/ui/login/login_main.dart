import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_theme.dart';
import 'package:silkeborgbeachvolley/helpers/userauth.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/main/enrollment_main.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_widget.dart';
import 'package:silkeborgbeachvolley/ui/livescore/main/livescore_main.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'package:silkeborgbeachvolley/ui/write_to/create/write_to_create_main.dart';

class Login extends StatefulWidget {
  static final routeName = "/login";
  final ValueChanged<bool> onLogIn;

  const Login({Key key, this.onLogIn}) : super(key: key);

  @override
  LoginState createState() {
    return new LoginState();
  }
}

class LoginState extends State<Login> {
  bool _showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        showAppBar: false, body: _main(context));
  }

  Widget _main(BuildContext context) {
    return Container(
        decoration: SilkeborgBeachvolleyTheme.gradientColorBoxDecoration,
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 70.0),
                child: Text(
                    FlutterI18n.translate(context, "login.loginMain.string1"),
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
                    setState(() {
                      _showSpinner = true;
                    });

                    //TODO: If return null there is a error
                    FirebaseUser user = await UserAuth.signInWithFacebook();

                    setState(() {
                      _showSpinner = false;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset("assets/images/flogo-HexRBG-Wht-100.png",
                          height: 30.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          FlutterI18n.translate(
                              context, "login.loginMain.string2"),
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _showSpinner ? LoaderSpinner() : Container(),
              Text(FlutterI18n.translate(context, "login.loginMain.string3"),
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                  textAlign: TextAlign.center),
              Text(FlutterI18n.translate(context, "login.loginMain.string4"),
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
              ),
              FlatButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed(Livescore.routeName);
                  },
                  label: Text("Live score"),
                  icon: Icon(Icons.live_tv),
                  textColor: Colors.white),
              FlatButton.icon(
                  textColor: Colors.white,
                  icon: Icon(Icons.mail),
                  label: Text(FlutterI18n.translate(
                      context, "login.loginMain.string6")),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (BuildContext context) => WriteToCreate(
                          user: null
                        )));
                  })
            ]));
  }
}
