import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:silkeborgbeachvolley/helpers/base_data_class.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/uuid_helpers.dart';
import 'package:silkeborgbeachvolley/ui/tournament_calendar/helpers/tournament_firestore.dart';

class TournamentData implements BaseData {
  String id;
  String title;
  String link;
  DateTime startDate;
  DateTime endDate;

  TournamentData(
      {this.id,
      @required this.title,
      @required this.link,
      @required this.startDate,
      @required this.endDate});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "link": link,
      "startDate": startDate,
      "endDate": endDate
    };
  }

  String get startDateFormatted {
    return DateTimeHelpers.ddMMyyyy(startDate);
  }

  String get endDateFormatted {
    return DateTimeHelpers.ddMMyyyy(endDate);
  }

  Future<void> save() {
    id = id ?? UuidHelpers.generateUuid();
    return TournamentFirestore.saveTournament(this);
  }

  Future<void> delete() {
    return TournamentFirestore.deleteTournament(id);
  }

  factory TournamentData.formMap(Map<String, dynamic> item) {
    return TournamentData(
        id: item["id"],
        title: item["title"] ?? "",
        link: item["link"] ?? "",
        startDate: item["startDate"],
        endDate: item["endDate"]);
  }

  static Future<List<TournamentData>> getTournaments() async {
    QuerySnapshot data = await TournamentFirestore.getTournaments();
    return data.documents.map((DocumentSnapshot doc) {
      return TournamentData.formMap(doc.data);
    }).toList();
  }
}
