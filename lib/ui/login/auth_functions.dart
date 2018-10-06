import 'package:flutter/material.dart';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:silkeborgbeachvolley/helpers/confirm_action_enum.dart';
import 'package:silkeborgbeachvolley/helpers/user_firestore.dart';
import 'package:silkeborgbeachvolley/helpers/userauth.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_sharedpref.dart';

Future<void> signInWithFacebook() async {
  final FirebaseUser user = await UserAuth.signInWithFacebook();

  if (user != null) _finalSignInTasks(user, "facebook");
}

Future<void> _finalSignInTasks(FirebaseUser user, String loginProvider) async {
  await UserFirestore.setUserInfo(user);
}

Future<void> logout() async {
  await UserAuth.signOutWithFacebook();
  await RankingSharedPref.removeIsItFirstTime();
}

Future<ConfirmAction> logoutConfirm(BuildContext context) async {
  ConfirmAction choise = await showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => SimpleDialog(
            contentPadding: EdgeInsets.all(10.0),
            title: Text("Log ud"),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text("Er du sikker på at du vil logge ud?",
                    textAlign: TextAlign.center),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SimpleDialogOption(
                    child: Text("Ja"),
                    onPressed: () {
                      Navigator.of(context).pop(ConfirmAction.yes);
                    },
                  ),
                  SimpleDialogOption(
                    child: Text("Nej"),
                    onPressed: () {
                      Navigator.of(context).pop(ConfirmAction.no);
                    },
                  )
                ],
              )
            ],
          ));

  return choise;
}
