import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:silkeborgbeachvolley/main_inheretedwidget.dart';
import 'package:silkeborgbeachvolley/main_material_app.dart';

void main() async {
  // debugPaintSizeEnabled=true;
  // debugPaintBaselinesEnabled=true;
  /// Set firestore to save and return dates as Timestamp
  final FirebaseApp app = FirebaseApp(name: "[DEFAULT]");
  final Firestore firestore = Firestore(app: app);
  await firestore.settings(timestampsInSnapshotsEnabled: true);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MainInherited(
    child: MainMaterialApp(),
    mode: SystemMode.debug,
  ));
}
