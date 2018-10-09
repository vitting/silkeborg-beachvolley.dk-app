class NotificationCategoryHelper {
  static const news = "news";
  static const play = "play";
  static const event ="event";
  static const none ="none";
  
  static String getNotificationCategoryAsString(NotificationCategory notificationCategory) {
    String type = NotificationCategoryHelper.none;
    if (notificationCategory == NotificationCategory.news) type = NotificationCategoryHelper.news;
    if (notificationCategory == NotificationCategory.event) type = NotificationCategoryHelper.event;
    if (notificationCategory == NotificationCategory.play) type = NotificationCategoryHelper.play;

    return type;
  }

  static NotificationCategory getNotificationCategoryStringAsType(String notificationCategory) {
    NotificationCategory type = NotificationCategory.none;
    if (notificationCategory == NotificationCategoryHelper.news) type = NotificationCategory.news;
    if (notificationCategory == NotificationCategoryHelper.event) type = NotificationCategory.event;
    if (notificationCategory == NotificationCategoryHelper.play) type = NotificationCategory.play;

    return type;
  }
}
enum NotificationCategory {
  news,
  play,
  event,
  none
}