import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';

class ConfirmDialogOptionsData {
  BulletinType type;
  Text title;
  List<Widget> body;

  ConfirmDialogOptionsData({this.type, this.title, this.body});
}