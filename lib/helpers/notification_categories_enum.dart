class NotificationCategoryHelper {
  static const news = "news";
  static const play = "play";
  static const event = "event";
  static const writeTo = "writeTo";
  static const writeToAdmin = "writeToAdmin";
  static const none = "none";

  static String getNotificationCategoryAsString(
      NotificationCategory notificationCategory) {
    String type = NotificationCategoryHelper.none;
    if (notificationCategory == NotificationCategory.news)
      type = NotificationCategoryHelper.news;
    if (notificationCategory == NotificationCategory.event)
      type = NotificationCategoryHelper.event;
    if (notificationCategory == NotificationCategory.play)
      type = NotificationCategoryHelper.play;
    if (notificationCategory == NotificationCategory.writeTo)
      type = NotificationCategoryHelper.writeTo;
    if (notificationCategory == NotificationCategory.writeToAdmin)
      type = NotificationCategoryHelper.writeToAdmin;

    return type;
  }

  static NotificationCategory getNotificationCategoryStringAsType(
      String notificationCategory) {
    NotificationCategory type = NotificationCategory.none;
    if (notificationCategory == NotificationCategoryHelper.news)
      type = NotificationCategory.news;
    if (notificationCategory == NotificationCategoryHelper.event)
      type = NotificationCategory.event;
    if (notificationCategory == NotificationCategoryHelper.play)
      type = NotificationCategory.play;
    if (notificationCategory == NotificationCategoryHelper.writeTo)
      type = NotificationCategory.writeTo;
    if (notificationCategory == NotificationCategoryHelper.writeToAdmin)
      type = NotificationCategory.writeToAdmin;

    return type;
  }
}

enum NotificationCategory { news, play, event, writeTo, writeToAdmin, none }
