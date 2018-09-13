class BulletinTypeHelper {
  static const news = "news";
  static const play = "play";
  static const event ="event";
  static const none = "none";

  static String getBulletinTypeAsString(BulletinType bulletinType) {
    String type = BulletinTypeHelper.none;
    if (bulletinType == BulletinType.news) type = BulletinTypeHelper.news;
    if (bulletinType == BulletinType.event) type = BulletinTypeHelper.event;
    if (bulletinType == BulletinType.play) type = BulletinTypeHelper.play;

    return type;
  }

  static BulletinType getBulletinTypeStringAsType(String bulletinType) {
    BulletinType type = BulletinType.none;
    if (bulletinType == BulletinTypeHelper.news) type = BulletinType.news;
    if (bulletinType == BulletinTypeHelper.event) type = BulletinType.event;
    if (bulletinType == BulletinTypeHelper.play) type = BulletinType.play;

    return type;
  }
}

enum BulletinType {
  news,
  play,
  event,
  none
}