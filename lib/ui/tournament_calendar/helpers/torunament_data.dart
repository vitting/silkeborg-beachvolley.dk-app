import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/system_helpers.dart';
import 'package:silkeborgbeachvolley/ui/tournament_calendar/helpers/tournament_firestore.dart';

class TournamentData {
  String id;
  String title;
  String body;
  String link;
  DateTime startDate;
  DateTime endDate;

  TournamentData(
      {this.id,
      @required this.title,
      @required this.body,
      @required this.link,
      @required this.startDate,
      @required this.endDate});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "body": body,
      "link": link,
      "startDate": Timestamp.fromDate(startDate),
      "endDate": Timestamp.fromDate(endDate)
    };
  }

  String startDateFormatted(BuildContext context) {
    return DateTimeHelpers.ddMMyyyy(context, startDate);
  }

  String startDateFormattedShort(BuildContext context) {
    return DateTimeHelpers.ddMM(context, startDate);
  }

  String endDateFormatted(BuildContext context) {
    return DateTimeHelpers.ddMMyyyy(context, endDate);
  }

  Future<void> save() {
    id = id ?? SystemHelpers.generateUuid();
    return TournamentFirestore.saveTournament(this);
  }

  Future<void> delete() {
    return TournamentFirestore.deleteTournament(id);
  }

  factory TournamentData.formMap(Map<String, dynamic> item) {
    return TournamentData(
        id: item["id"],
        title: item["title"],
        body: item["body"] ?? "",
        link: item["link"] ?? "",
        startDate: (item["startDate"] as Timestamp).toDate(),
        endDate: (item["endDate"] as Timestamp).toDate());
  }

  static Future<List<TournamentData>> getTournaments() async {
    QuerySnapshot data = await TournamentFirestore.getTournaments();
    return data.documents.map((DocumentSnapshot doc) {
      return TournamentData.formMap(doc.data);
    }).toList();
  }
}
