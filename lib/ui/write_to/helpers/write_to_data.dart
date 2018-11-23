import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:silkeborgbeachvolley/helpers/system_helpers.dart';
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
  String subType;
  bool newMessageStatus;
  bool deleted;

  WriteToData(
      {this.id,
      this.deleted = false,
      this.createdDate,
      this.sendToEmailStatus = false,
      @required this.newMessageStatus,
      @required this.fromUserId,
      @required this.sendToUserId,
      @required this.message,
      @required this.messageRepliedToId,
      @required this.fromName,
      @required this.fromEmail,
      @required this.sendToEmailSubject,
      @required this.sendToEmail,
      @required this.sendToName,
      @required this.sendToPhotoUrl,
      @required this.type,
      @required this.subType,
      @required this.fromPhotoUrl});

  factory WriteToData.fromMap(Map<String, dynamic> item) {
    return WriteToData(
        id: item["id"],
        createdDate: item["createdDate"],
        deleted: item["deleted"],
        newMessageStatus: item["newMessageStatus"],
        type: item["type"],
        subType: item["subType"],
        fromUserId: item["fromUserId"],
        sendToUserId: item["sendToUserId"],
        messageRepliedToId: item["messageRepliedToId"],
        fromName: item["fromName"],
        fromEmail: item["fromEmail"],
        message: item["message"],
        fromPhotoUrl: item["fromPhotoUrl"],
        sendToEmailStatus: item["sendToEmailStatus"],
        sendToEmail: item["sendToEmail"],
        sendToName: item["sendToName"],
        sendToPhotoUrl: item["sendToPhotoUrl"],
        sendToEmailSubject: item["sendToEmailSubject"]);
  }

  Future<void> delete() {
    return WriteToFirestore.deleteMessage(id);
  }

  Future<void> save() {
    id = id ?? SystemHelpers.generateUuid();
    createdDate = createdDate ?? Timestamp.now();
    if (messageRepliedToId == null) {
      return WriteToFirestore.saveMessage(this);
    } else {
      return WriteToFirestore.saveReplyMessage(this);
    }
  }

  Future<void> setNewMessageStatus(bool status) {
    newMessageStatus = status;
    return WriteToFirestore.setNewMessageStatus(id, status);
  }

  Future<void> setSendEmailStatus(bool status) {
    sendToEmailStatus = status;
    
    if (messageRepliedToId == null) {
      return WriteToFirestore.setSendEmailStatus(id, status);
    } else {
      return WriteToFirestore.setSendEmailReplyStatus(id, status);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "fromUserId": fromUserId,
      "newMessageStatus": newMessageStatus,
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
      "type": type,
      "subType": subType
    };
  }

  Stream<QuerySnapshot> getReplies() {
    return WriteToFirestore.getAllReplyMessage(id);
  }

  static Future<List<WriteToData>> getAllMessagesReceived() {
    return WriteToFirestore.getAllMessages();
  }

  static Stream<QuerySnapshot> getAllMessagesSentMailAsStream(int limit) {
    return WriteToFirestore.getAllMessagesSentMailAsStream(limit);
  }

  static Future<List<WriteToData>> getAllMessagesByUserId(String userId) {
    return WriteToFirestore.getAllMessagesByUserId(userId);
  }
}
