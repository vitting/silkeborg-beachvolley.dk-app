import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';

class ItemFieldsCreate {
  BulletinType type = BulletinType.news;
  String body = "";
  DateTime eventStartDate;
  DateTime eventEndDate;
  TimeOfDay eventStartTime;
  TimeOfDay eventEndTime;
  String eventLocation = "";
  String eventTitle = "";
}
