import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/userauth.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

class TestWidget extends StatefulWidget {
  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  @override
    void initState() {
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
                UserAuth.signInWithGoogle().then((FirebaseUser value) {
                  print("$value");
                }).catchError((onError) {
                  print(onError);
                });
              },
              child: Text("Google Signin")
            ),
            RaisedButton(
              onPressed: () {
                UserAuth.signOutWithGoogle();
              },
              child: Text("Google Signout")
            ),
            RaisedButton(
              onPressed: () {
                UserAuth.signInWithFacebook().then((FirebaseUser value) {
                  print("$value");
                }).catchError((error) => print(error));
              },
              child: Text("Facebook Signin")
            ),
            RaisedButton(
              onPressed: () {
                UserAuth.signOutWithFacebook();
              },
              child: Text("Facebook SignOut")
            ),
            RaisedButton(
              onPressed: () {
                UserAuth.currentUser.then((user) {
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