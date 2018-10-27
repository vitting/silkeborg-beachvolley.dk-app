import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:silkeborgbeachvolley/helpers/base_data_class.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/uuid_helpers.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/livescore/helpers/livescore_firestore.dart';
import 'package:silkeborgbeachvolley/ui/livescore/helpers/livescore_sets_played_data.dart';

class LivescoreData implements BaseData {
  /// Id of match.
  String id;

  /// Title/description of match.
  String title;

  /// Id of user that created the match.
  String userId;

  /// Date the match was created.
  Timestamp createdDate;

  /// Name of Player 1 Team 1.
  String namePlayer1Team1;

  /// Name of Player 2 Team 1.
  String namePlayer2Team1;

  /// Name of Player 1 Team 2.
  String namePlayer1Team2;

  /// Name of Player 2 Team 2.
  String namePlayer2Team2;

  /// Date/time the match is estimated to start.
  DateTime matchDate;

  /// Date/time the match actually started.
  DateTime matchStartedAt;

  /// Date/time the match ended.
  DateTime matchEndedAt;

  /// Set score for Team 1.
  int setTeam1;

  /// Set score for Team 2.
  int setTeam2;

  /// Points for Team 1.
  int pointsTeam1;

  /// Points for Team 2.
  int pointsTeam2;

  /// Timeouts for Team 1.
  int timeoutsTeam1;

  /// Timeouts for Team 2.
  int timeoutsTeam2;

  /// Indicate if match is started. Null: not started, True: the match is started, False: the match has ended.
  bool active;

  /// Which Team won the match.
  int winnerTeam;

  /// Which Team starts the match serving.
  int startTeam;

  /// Which Team currently is serving.
  int activeTeam;

  /// Message to show on scoreboard. 0 = no message.
  int matchMessage;

  ///Team message is selected from
  int matchMessageTeam;

  /// Snapshot of ended sets
  List<LivescoreSetsPlayedData> setsPlayed;

  LivescoreData(
      {this.id,
      this.createdDate,
      this.userId,
      @required this.matchDate,
      @required this.title,
      @required this.namePlayer1Team1,
      @required this.namePlayer2Team1,
      @required this.namePlayer1Team2,
      @required this.namePlayer2Team2,
      this.matchStartedAt,
      this.matchEndedAt,
      this.winnerTeam,
      this.setTeam1 = 0,
      this.setTeam2 = 0,
      this.pointsTeam1 = 0,
      this.pointsTeam2 = 0,
      this.timeoutsTeam1 = 0,
      this.timeoutsTeam2 = 0,
      this.matchMessage = 0,
      this.matchMessageTeam = 0,
      this.startTeam = 0,
      this.activeTeam = 0,
      this.active,
      this.setsPlayed});

  factory LivescoreData.fromMap(Map<String, dynamic> item) {
    return LivescoreData(
      id: item["id"],
      userId: item["userId"],
      title: item["title"],
      createdDate: item["createdDate"],
      matchDate: (item["matchDate"] as Timestamp).toDate(),
      matchStartedAt: item["matchStartedAt"] == null
          ? null
          : (item["matchStartedAt"] as Timestamp).toDate(),
      matchEndedAt: item["matchEndedAt"] == null
          ? null
          : (item["matchEndedAt"] as Timestamp).toDate(),
      namePlayer1Team1: item["namePlayer1Team1"],
      namePlayer2Team1: item["namePlayer2Team1"],
      namePlayer1Team2: item["namePlayer1Team2"],
      namePlayer2Team2: item["namePlayer2Team2"],
      winnerTeam: item["winnerTeam"],
      setTeam1: item["setTeam1"],
      setTeam2: item["setTeam2"],
      pointsTeam1: item["pointsTeam1"],
      pointsTeam2: item["pointsTeam2"],
      timeoutsTeam1: item["timeoutsTeam1"],
      timeoutsTeam2: item["timeoutsTeam2"],
      matchMessage: item["matchMessage"],
      matchMessageTeam: item["matchMessageTeam"],
      startTeam: item["startTeam"],
      activeTeam: item["activeTeam"],
      active: item["active"],
      setsPlayed: item["setsPlayed"] == null
          ? []
          : (item["setsPlayed"] as List<dynamic>)
              .map<LivescoreSetsPlayedData>((dynamic value) {
              return LivescoreSetsPlayedData.fromMap(value);
            }).toList(),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userId": userId,
      "title": title,
      "createdDate": createdDate,
      "matchDate": Timestamp.fromDate(matchDate),
      "matchStartedAt":
          matchStartedAt == null ? null : Timestamp.fromDate(matchStartedAt),
      "matchEndedAt":
          matchEndedAt == null ? null : Timestamp.fromDate(matchEndedAt),
      "namePlayer1Team1": namePlayer1Team1,
      "namePlayer2Team1": namePlayer2Team1,
      "namePlayer1Team2": namePlayer1Team2,
      "namePlayer2Team2": namePlayer2Team2,
      "winnerTeam": winnerTeam,
      "setTeam1": setTeam1,
      "setTeam2": setTeam2,
      "pointsTeam1": pointsTeam1,
      "pointsTeam2": pointsTeam2,
      "timeoutsTeam1": timeoutsTeam1,
      "timeoutsTeam2": timeoutsTeam2,
      "matchMessage": matchMessage,
      "matchMessageTeam": matchMessageTeam,
      "startTeam": startTeam,
      "activeTeam": activeTeam,
      "active": active,
      "setsPlayed": setsPlayed == null
          ? []
          : setsPlayed
              .map<Map<String, dynamic>>((LivescoreSetsPlayedData data) {
              return data.toMap();
            }).toList()
    };
  }

  String matchDateFormatted(BuildContext context) {
    return DateTimeHelpers.ddMMyyyy(context, matchDate);
  }

  String matchDateWithTimeFormatted(BuildContext context) {
    return DateTimeHelpers.ddMMyyyyHHnn(context, matchDate);
  }

  String matchStartedAtFormatted() {
    return DateTimeHelpers.ddmmyyyy(matchStartedAt);
  }

  String matchStartedAtTimeFormatted() {
    return matchStartedAt == null ? null : DateTimeHelpers.hhnn(matchStartedAt);
  }

  String matchEndedAtFormatted() {
    return DateTimeHelpers.ddmmyyyy(matchEndedAt);
  }

  String matchEndedAtTimeFormatted() {
    return matchEndedAt == null ? null : DateTimeHelpers.hhnn(matchEndedAt);
  }

  String matchPlayTime() {
    if (matchStartedAt == null) return null;
    return matchEndedAt != null
        ? matchEndedAt.difference(matchStartedAt).inMinutes.toString()
        : DateTime.now().difference(matchStartedAt).inMinutes.toString();
  }

  Future<void> setPointsAndTimeouts(
      int pointsTeam1, int pointsTeam2, int timeoutsTeam1, int timeoutsTeam2) {
    this.pointsTeam1 = pointsTeam1;
    this.pointsTeam2 = pointsTeam2;
    this.timeoutsTeam1 = timeoutsTeam1;
    this.timeoutsTeam2 = timeoutsTeam2;
    return LivescoreFirestore.setPointsTimeouts(
        id, pointsTeam1, pointsTeam2, timeoutsTeam1, timeoutsTeam2);
  }

  Future<void> addSet(int team) async {
    int setValue;
    if (team == 1) {
      setValue = ++setTeam1;
    }

    if (team == 2) {
      setValue = ++setTeam2;
    }

    LivescoreSetsPlayedData setData = LivescoreSetsPlayedData(
        setNumber: setTeam1 + setTeam2,
        pointsTeam1: pointsTeam1,
        pointsTeam2: pointsTeam2,
        setTeam1: setTeam1,
        setTeam2: setTeam2,
        timeoutsTeam1: timeoutsTeam1,
        timeoutsTeam2: timeoutsTeam2,
        timestampSet: Timestamp.now());

    setsPlayed.add(setData);

    return LivescoreFirestore.updateSet(id, setValue, team, setData);
  }

  Future<void> subtractSet(int team) {
    int setValue = 0;
    if (team == 1) {
      setValue = setTeam1 == 0 ? 0 : --setTeam1;
    }

    if (team == 2) {
      setValue = setTeam2 == 0 ? 0 : --setTeam2;
    }

    return LivescoreFirestore.updateSet(id, setValue, team, null);
  }

  Future<void> addPoints(int team) {
    int pointsValue = 0;
    if (team == 1) {
      pointsValue = ++pointsTeam1;
    }

    if (team == 2) {
      pointsValue = ++pointsTeam2;
    }

    return LivescoreFirestore.updatePoints(id, pointsValue, team);
  }

  Future<void> subtractPoints(int team) {
    int pointsValue = 0;
    if (team == 1) {
      pointsValue = pointsTeam1 == 0 ? 0 : --pointsTeam1;
    }

    if (team == 2) {
      pointsValue = pointsTeam2 == 0 ? 0 : --pointsTeam2;
    }

    return LivescoreFirestore.updatePoints(id, pointsValue, team);
  }

  Future<void> addTimeouts(int team) {
    int timeoutsValue = 0;
    if (team == 1) {
      timeoutsValue = ++timeoutsTeam1;
    }

    if (team == 2) {
      timeoutsValue = ++timeoutsTeam2;
    }

    return LivescoreFirestore.updateTimeouts(id, timeoutsValue, team);
  }

  Future<void> subtractTimeouts(int team) {
    int timeoutsValue = 0;
    if (team == 1) {
      timeoutsValue = timeoutsTeam1 == 0 ? 0 : --timeoutsTeam1;
    }

    if (team == 2) {
      timeoutsValue = timeoutsTeam2 == 0 ? 0 : --timeoutsTeam2;
    }

    return LivescoreFirestore.updateTimeouts(id, timeoutsValue, team);
  }

  Future<void> markGameAsStarted(int team) {
    matchStartedAt = Timestamp.now().toDate();
    active = true;
    return LivescoreFirestore.updateMatchAsStarted(id, matchStartedAt, team);
  }

  Future<void> markGameAsWon(int team) {
    matchEndedAt = Timestamp.now().toDate();
    active = false;
    return LivescoreFirestore.updateMatchAsEnded(id, matchEndedAt, team);
  }

  Future<void> setMatchMessage(int messageNumber, int team) {
    matchMessage = messageNumber;
    matchMessageTeam = team;
    return LivescoreFirestore.updateMatchMessage(id, matchMessage, matchMessageTeam);
  }

  @override
  Future<void> save() {
    id = id ?? UuidHelpers.generateUuid();
    userId = userId ?? Home.loggedInUser.uid;
    createdDate = createdDate ?? Timestamp.now();
    return LivescoreFirestore.saveMatch(this);
  }

  @override
  Future<void> delete() {
    return LivescoreFirestore.deleteMatch(id);
  }

  static Stream<QuerySnapshot> getMatchesUpcoming() {
    return LivescoreFirestore.getAllUpcomingMatchesAsStream();
  }

  static Stream<QuerySnapshot> getMatchesStarted() {
    return LivescoreFirestore.getAllStartedMatchesAsStream();
  }

  static Stream<QuerySnapshot> getMatchesEnded() {
    return LivescoreFirestore.getAllEndedMatchesAsStream();
  }

  static Stream<DocumentSnapshot> getMatch(String liveScoreId) {
    return LivescoreFirestore.getMatchAsStream(liveScoreId);
  }
}
