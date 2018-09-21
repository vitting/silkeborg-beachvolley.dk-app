import 'dart:async';

import 'package:meta/meta.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_firestorage.dart';

class BulletinImageData {
  String name;
  String folder;
  String link;

  BulletinImageData({@required this.name, @required this.folder, @required this.link});

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "folder": folder,
      "link": link
    };
  }

  static BulletinImageData fromMap(map) {
    return BulletinImageData(
      name: map["name"] ?? "",
      folder: map["folder"] ?? "",
      link: map["link"] ?? ""
    );
  }

  Future<void> delete() {
    return BulletinFireStorage.deleteFromFirebaseStorage(name, folder);
  }
}
