class RankingPlayerStatsData {
  int won;
  int lost;
  int total;

  RankingPlayerStatsData({this.total = 0, this.won = 0, this.lost = 0});

  Map<String, dynamic> toMap() {
    return {"total": total, "won": won, "lost": lost};
  }

  static RankingPlayerStatsData fromMap(Map<dynamic, dynamic> item) {
    return RankingPlayerStatsData(
        total: item["total"] ?? 0,
        won: item["won"] ?? 0,
        lost: item["lost"] ?? 0);
  }
}
