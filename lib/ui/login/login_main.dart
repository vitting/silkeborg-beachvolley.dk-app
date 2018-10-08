import "package:flutter/material.dart";
import 'package:silkeborgbeachvolley/ui/enrollment/enrollment_main.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'auth_functions.dart' as authFunctions;

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
      padding: EdgeInsets.only(left: 30.0, right: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 70.0, bottom: 5.0),
            child: Text("Velkommen til Silkeborg Beachvolley",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20.0)),
          ),
          Image.asset("assets/images/logo_white_250x250.png",
              width: 100.0, height: 100.0),
          RaisedButton(
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
                    height: 40.0),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Text(
                    "Log ind med Facebook",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
              ],
            ),
          ),
          Text(
              "Det med småt - Du skal logge ind med din Facebook konto for at kunne bruge denne app. Vi beder ikke om nogen specille tilladelser fra Facebook da vi kun skal bruge dit navn og profil billede. Dvs. vi kan ikke slå noget op på vegne af dig eller har adgang til dine billeder og venner.",
              style: TextStyle(color: Colors.white, fontSize: 12.0),
              textAlign: TextAlign.center),
          Text(
              "Hvis du kun vil bruge denne app til at melde dig ind i Silkeborg Beachvolley så tryk herunder.",
              style: TextStyle(color: Colors.white, fontSize: 12.0),
              textAlign: TextAlign.center),
          FlatButton.icon(
            onPressed: () {
              Navigator.of(context).pushNamed(Enrollment.routeName);
            },
            label: Text(
              "Indmeldelse i Silkeborg Beachvolley",
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
