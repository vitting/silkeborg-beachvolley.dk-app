import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:silkeborgbeachvolley/ui/main_inheretedwidget.dart';
import 'package:silkeborgbeachvolley/ui/main_material_app.dart';
import 'package:vibrate/vibrate.dart';

void main() async {
  debugPaintSizeEnabled=false;
  debugPaintBaselinesEnabled=false;
  /// Set firestore to save and return dates as Timestamp
  final FirebaseApp app = FirebaseApp(name: "[DEFAULT]");
  final Firestore firestore = Firestore(app: app);
  await firestore.settings(timestampsInSnapshotsEnabled: true);
  /// Set screen orientation always to be portrait
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  /// Get info if device can vibrate
  final bool canVibrate = await Vibrate.canVibrate;
  
  runApp(MainInherited(
      mode: SystemMode.develop,
      canVibrate: canVibrate,
      child: MainMaterialApp()));
}
