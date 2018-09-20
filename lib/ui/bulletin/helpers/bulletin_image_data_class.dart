import 'dart:async';

import 'package:meta/meta.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_firestorage.dart';

class BulletinImageData {
  String name;
  String folder;

  BulletinImageData({@required this.name, @required this.folder});

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "folder": folder
    };
  }

  static BulletinImageData fromMap(map) {
    return BulletinImageData(
      name: map["name"] ?? "",
      folder: map["folder"] ?? ""
    );
  }

  Future<void> delete() {
    return BulletinFireStorage.deleteFromFirebaseStorage(name, folder);
  }
}
