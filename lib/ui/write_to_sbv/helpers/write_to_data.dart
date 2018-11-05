import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:silkeborgbeachvolley/helpers/base_data_class.dart';
import 'package:silkeborgbeachvolley/helpers/uuid_helpers.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/write_to_sbv/helpers/write_to_firestore.dart';

class WriteToData implements BaseData {
  String id;
  String fromUserId;
  String sendToUserId;
  String messageRepliedToId;
  Timestamp createdDate;
  String fromName;
  String fromEmail;
  String message;
  bool sendToEmailStatus;
  String sendToEmail;
  String sendToEmailSubject;
  String sendToName;
  String fromPhotoUrl;
  String type;
  bool deleted;

  WriteToData(
      {this.id,
      this.fromUserId,
      this.sendToUserId,
      this.createdDate,
      @required this.message,
      @required this.messageRepliedToId,
      this.fromName,
      this.fromEmail,
      this.sendToEmailStatus,
      this.sendToEmailSubject,
      this.sendToEmail,
      this.sendToName,
      this.deleted = false,
      @required this.type,
      this.fromPhotoUrl});

  factory WriteToData.fromMap(Map<String, dynamic> item) {
    return WriteToData(
        id: item["id"],
        type: item["type"],
        fromUserId: item["fromUserId"],
        sendToUserId: item["sendToUserId"],
        messageRepliedToId: item["messageRepliedToId"],
        createdDate: item["createdDate"],
        fromName: item["fromName"],
        fromEmail: item["fromEmail"],
        message: item["message"],
        fromPhotoUrl: item["fromPhotoUrl"],
        sendToEmailStatus: item["sendToEmailStatus"],
        sendToEmail: item["sendToEmail"],
        sendToName: item["sendToName"], 
        sendToEmailSubject: item["sendToEmailSubject"],
        deleted: item["deleted"]
        );
  }

  @override
  Future<void> delete() {
    return WriteToFirestore.deleteMessage(id);
  }

  @override
  Future<void> save() {
    id = UuidHelpers.generateUuid();
    createdDate = Timestamp.now();
    fromEmail = fromEmail != null
        ? fromEmail
        : Home.loggedInUser != null ? Home.loggedInUser.email : null;
    fromUserId = Home.loggedInUser != null ? Home.loggedInUser.uid : null;
    fromPhotoUrl = fromPhotoUrl != null ? fromPhotoUrl : Home.loggedInUser != null ? Home.loggedInUser.photoUrl : null;
    fromName = fromName != null
        ? fromName
        : Home.loggedInUser != null ? Home.loggedInUser.displayName : null;
    if (messageRepliedToId == null) {
      return WriteToFirestore.saveMessage(this);
    } else {
      return WriteToFirestore.saveReplyMessage(this);
    }
  }

  Future<void> setSendEmailStatus(bool status) {
    return WriteToFirestore.setSendEmailStatus(id, status);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "fromUserId": fromUserId,
      "messageRepliedToId": messageRepliedToId,
      "createdDate": createdDate,
      "fromName": fromName,
      "fromEmail": fromEmail,
      "message": message,
      "fromPhotoUrl": fromPhotoUrl,
      "sendToEmailStatus": sendToEmailStatus,
      "sendToEmail": sendToEmail,
      "sendToEmailSubject": sendToEmailSubject,
      "sendToName": sendToName,
      "sendToUserId": sendToUserId,
      "deleted": deleted,
      "type": type
    };
  }

  Stream<QuerySnapshot> getReplies() {
    return WriteToFirestore.getAllReplyMessage(id);
  }

  static Stream<QuerySnapshot> getAllMessages() {
    return WriteToFirestore.getAllMessages();
  }

  static Stream<QuerySnapshot> getAllMessagesByUserId(String userId) {
    return WriteToFirestore.getAllMessagesByUserId(userId);
  }
}
