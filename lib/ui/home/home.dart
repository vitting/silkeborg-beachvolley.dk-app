import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/userauth.dart';
import 'package:silkeborgbeachvolley/ui/home/news_main.dart';
import 'package:silkeborgbeachvolley/ui/login/login_main.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoggedIn = false;
  @override
  void initState() {
    super.initState();
    UserAuth.firebaseAuth.onAuthStateChanged.listen((user) {
      setState(() {
        isLoggedIn = user == null ? false : true;        
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoggedIn ? News() : Login();
  }
}
