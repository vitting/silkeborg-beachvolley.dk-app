import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/userauth.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/bulletin_main.dart';
import 'package:silkeborgbeachvolley/ui/login/login_main.dart';

class Home extends StatefulWidget {
  static FirebaseUser loggedInUser;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isLoggedIn = false;
  @override
  void initState() {
    super.initState();
    UserAuth.firebaseAuth.onAuthStateChanged.listen((user) {
      Home.loggedInUser = user;

      setState(() {
        _isLoggedIn = user == null ? false : true;        
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn ? Bulletin() : Login();
  }
}
