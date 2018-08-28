import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();
final FacebookLogin _facebookSignIn = new FacebookLogin();

class TestWidget extends StatefulWidget {
  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  bool _isLoggedIn = false;

  @override
    void initState() {
      //User is not signed in
      // if (_auth.currentUser() == null) {
      //   setState(() {
      //     _isLoggedIn = false;          
      //   });
      // } else {
      //   setState(() {
      //     _isLoggedIn = true;          
      //   });
      // }

      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
      title: "Test",
      body: Container(
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                _signInWithGoogle().then((String value) {
                  print(value);
                }).catchError((onError) {
                  print(onError);
                });
              },
              child: Text("Google Signin")
            ),
            RaisedButton(
              onPressed: () {
                _signOutWithGoogle();
              },
              child: Text("Google Signout")
            ),
            RaisedButton(
              onPressed: () {
                _signInWithFacebook().then((String value) {
                  print(value);
                }).catchError((error) => print(error));
              },
              child: Text("Facebook Signin")
            ),
            RaisedButton(
              onPressed: () {
                _signOutWithFacebook();
              },
              child: Text("Facebook SignOut")
            ),
            RaisedButton(
              onPressed: () {
                _facebookSignIn.isLoggedIn.then((value) => print(value)).catchError((error) => print(error));
                FirebaseAuth.instance.signOut();
              },
              child: Text("Firebase SignOut")
            ),
            RaisedButton(
              onPressed: () {
                _currentUser().then((user) {
                  print("CurrentUSER: $user");
                }).catchError((onError) {
                  print(onError);
                });
              },
              child: Text("Current User")
            )
          ],
        ),
      ),
    );
  }


  Future<void> _signOutWithFacebook() async {
    await _facebookSignIn.logOut();
    await _auth.signOut();
  }

  Future<String> _signInWithFacebook() async {
    FacebookLoginResult result = await _facebookSignIn.logInWithReadPermissions(["email"]);
    FirebaseUser user = await _auth.signInWithFacebook(
      accessToken: result.accessToken.token
    );

    final FirebaseUser currentUser = await _auth.currentUser();
    return 'signInWithFacebook succeeded: $user';
  }


  Future<FirebaseUser> _currentUser() async  {
    final FirebaseUser currentUser = await _auth.currentUser();
    
    return currentUser;
  }

  Future<void> _signOutWithGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<String> _signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser currentUser = await _auth.currentUser();
    return 'signInWithGoogle succeeded: $user';
  }
}


//   Future<Null> _askedToLead(BuildContext context) async {
  //     final _formKey = GlobalKey<FormState>();

  //     var result = await showDialog<int>(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return new SimpleDialog(
  //             title: const Text('Opret nyhed'),
  //             children: <Widget>[
  //               Form(
  //                 key: _formKey,
  //                 child: Column(
  //                   children: <Widget>[
  //                     TextFormField(
  //                       decoration: InputDecoration(labelText: "Titel"),
  //                       onSaved: (String value) {},
  //                     ),
  //                     TextFormField(
  //                       decoration: InputDecoration(labelText: "Titel"),
  //                       onSaved: (String value) {},
  //                     )
  //                   ],
  //                 ),
  //               )
  //             ],
  //           );
  //         });

  //     print(result);
  //   }
  // }

  // Future _openAddEntryDialog() async {
  //   WeightSave save =
  //       await Navigator.of(context).push(new MaterialPageRoute<WeightSave>(
  //           builder: (BuildContext context) {
  //             return new AddEntryDialog();
  //           },
  //           fullscreenDialog: true));
  //   if (save != null) {
  //     _addWeightSave(save);
  //   }