import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/main_material_app.dart';

void main() async {
  /// Set firestore to save and return dates as Timestamp
  final FirebaseApp app = FirebaseApp(name: "[DEFAULT]");
  final Firestore firestore = Firestore(app: app);
  await firestore.settings(timestampsInSnapshotsEnabled: true);

  runApp(MainMaterialApp());
}
