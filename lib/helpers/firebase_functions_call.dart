import 'dart:async';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_items_count_data.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_sharedpref.dart';

class FirebaseFunctions {
  static Future<BulletinItemsCount> getBulletinsItemCount() async {
    BulletinItemsCount bulletinItemsCount = BulletinItemsCount();
    int dateInMilliSeconds =
        await BulletinSharedPref.getLastCheckedDateInMilliSeconds();

    if (dateInMilliSeconds != null && dateInMilliSeconds != 0) {
      try {
        final dynamic response = await CloudFunctions.instance.call(
          functionName: 'getBulletinsCount',
          parameters: <String, dynamic>{'date': dateInMilliSeconds},
        );

        bulletinItemsCount = BulletinItemsCount.fromMap(response);
      } on CloudFunctionsException catch (e) {
        print('caught firebase functions exception');
        print(e.code);
        print(e.message);
        print(e.details);
      } catch (e) {
        print('caught generic exception');
        print(e);
      }
    }

  return bulletinItemsCount;
  }
}
