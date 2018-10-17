import 'dart:io';
import 'dart:isolate';

import 'package:meta/meta.dart';

class ImageParamData {
  final String firebaseStorageFolder;
  final int imageSize;
  final File file;
  final Directory tempDir;
  final String fileName;
  SendPort sendPort;
  ImageParamData(
      {@required this.file,
      @required this.sendPort,
      @required this.imageSize,
      @required this.firebaseStorageFolder,
      @required this.tempDir,
      @required this.fileName});
}
