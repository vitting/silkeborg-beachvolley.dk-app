import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:silkeborgbeachvolley/helpers/uuid_helpers.dart';
import 'package:silkeborgbeachvolley/ui/write_to/helpers/write_to_firestore.dart';

class WriteToData {
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
  String sendToPhotoUrl;
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
      this.sendToPhotoUrl,
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
        sendToPhotoUrl: item["sendToPhotoUrl"],
        sendToEmailSubject: item["sendToEmailSubject"],
        deleted: item["deleted"]);
  }

  Future<void> delete() {
    return WriteToFirestore.deleteMessage(id);
  }

  Future<void> save(FirebaseUser user) {
    id = UuidHelpers.generateUuid();
    createdDate = Timestamp.now();
    fromEmail =
        fromEmail != null ? fromEmail : user != null ? user.email : null;
    fromUserId = user != null ? user.uid : null;
    fromPhotoUrl = fromPhotoUrl != null
        ? fromPhotoUrl
        : user != null ? user.photoUrl : "public";
    fromName =
        fromName != null ? fromName : user != null ? user.displayName : null;
    if (messageRepliedToId == null) {
      return WriteToFirestore.saveMessage(this);
    } else {
      return WriteToFirestore.saveReplyMessage(this);
    }
  }

  Future<void> setSendEmailStatus(bool status) {
    return WriteToFirestore.setSendEmailStatus(id, status);
  }

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
      "sendToPhotoUrl": sendToPhotoUrl,
      "sendToUserId": sendToUserId,
      "deleted": deleted,
      "type": type
    };
  }

  Stream<QuerySnapshot> getReplies() {
    return WriteToFirestore.getAllReplyMessage(id);
  }

  static Stream<QuerySnapshot> getAllMessagesReceived() {
    return WriteToFirestore.getAllMessagesReceived();
  }

  static Stream<QuerySnapshot> getAllMessagesSentMessage() {
    return WriteToFirestore.getAllMessagesSentMessage();
  }

  static Stream<QuerySnapshot> getAllMessagesSentMail() {
    return WriteToFirestore.getAllMessagesSentMail();
  }

  static Stream<QuerySnapshot> getAllMessagesSentByUserId(String userId) {
    return WriteToFirestore.getAllMessagesSentByUserId(userId);
  }

  static Stream<QuerySnapshot> getAllMessagesReceivedByUserId(String userId) {
    return WriteToFirestore.getAllMessagesReceivedByUserId(userId);
  }
}
