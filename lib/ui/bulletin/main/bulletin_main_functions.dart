import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';

String getTitle(BulletinType type) {
  String title;
  if (type == BulletinType.news) title = "Nyheder";
  if (type == BulletinType.event) title = "Begivenheder";
  if (type == BulletinType.play) title = "Spil";
  return title;
}

BulletinType getSelectedType(int selected) {
    BulletinType type = BulletinType.news;
    if (selected == 0) type = BulletinType.news;
    if (selected == 1) type = BulletinType.event;
    if (selected == 2) type = BulletinType.play;

    return type;
  }