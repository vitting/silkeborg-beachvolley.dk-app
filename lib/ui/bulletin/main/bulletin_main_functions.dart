import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';

String getTitle(BuildContext context, BulletinType type) {
  String title;
  if (type == BulletinType.news)
    title = FlutterI18n.translate(
        context, "bulletin.bulletinMainFunctions.string1");
  if (type == BulletinType.event)
    title = FlutterI18n.translate(
        context, "bulletin.bulletinMainFunctions.string2");
  if (type == BulletinType.play)
    title = FlutterI18n.translate(
        context, "bulletin.bulletinMainFunctions.string3");
  return title;
}

BulletinType getSelectedType(int selected) {
  BulletinType type = BulletinType.news;
  if (selected == 0) type = BulletinType.news;
  if (selected == 1) type = BulletinType.event;
  if (selected == 2) type = BulletinType.play;

  return type;
}
