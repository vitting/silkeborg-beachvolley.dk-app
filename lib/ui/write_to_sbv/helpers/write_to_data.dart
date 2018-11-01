import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:silkeborgbeachvolley/helpers/base_data_class.dart';
import 'package:silkeborgbeachvolley/helpers/uuid_helpers.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/write_to_sbv/helpers/write_to_firestore.dart';

class WriteToData implements BaseData {
  String id;
  String userId;
  String messageRepliedToId;
  Timestamp createdDate;
  String name;
  String email;
  String message;

  WriteToData(
      {this.id,
      this.userId,
      this.messageRepliedToId,
      this.createdDate,
      @required this.name,
      @required this.email,
      @required this.message});

  factory WriteToData.fromMap(Map<String, dynamic> item) {
    return WriteToData(
        id: item["id"],
        userId: item["userId"],
        messageRepliedToId: item["messageRepliedToId"],
        createdDate: item["createdDate"],
        name: item["name"],
        email: item["email"],
        message: item["message"]);
  }

  @override
  Future<void> delete() {
    return WriteToFirestore.deleteMessage(id);
  }

  @override
  Future<void> save() {
    id = UuidHelpers.generateUuid();
    createdDate = Timestamp.now();
    userId = Home.loggedInUser != null ? Home.loggedInUser.uid : null;
    return WriteToFirestore.saveMessage(this);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userId": userId,
      "messageRepliedToId": messageRepliedToId,
      "createdDate": createdDate,
      "name": name,
      "email": email,
      "message": message
    };
  }
}
