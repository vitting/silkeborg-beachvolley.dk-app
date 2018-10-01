class BulletinItemsCount {
  final int newsCount;
  final int eventCount;
  final int playCount;
  BulletinItemsCount({this.newsCount = 0, this.eventCount = 0, this.playCount = 0});

  factory BulletinItemsCount.fromMap(dynamic item) {
    return BulletinItemsCount(
      newsCount: item["newsCount"] ?? 0,
      eventCount: item["eventCount"] ?? 0,
      playCount: item["playCount"] ?? 0,
    );
  }
}