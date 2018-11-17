enum NotificationState { message, resume, launch, none }

class NotificationData {
  final String type;
  final String subType;
  final NotificationState state;

  const NotificationData({this.type, this.subType, this.state});
}
