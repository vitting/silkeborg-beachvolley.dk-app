enum NotificationState {
  message,
  resume,
  launch,
  none
}

class NotificationData {
  final String type;
  final String bulletinType;
  final NotificationState state;

  NotificationData({this.type, this.bulletinType, this.state});
}