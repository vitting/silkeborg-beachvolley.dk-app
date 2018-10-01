import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';

class ConfirmDialogOptions {
  BulletinType type;
  Text title;
  List<Widget> body;

  ConfirmDialogOptions({this.type, this.title, this.body});
}