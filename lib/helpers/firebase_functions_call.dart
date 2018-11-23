import 'dart:async';
import 'package:cloud_functions/cloud_functions.dart';

class FirebaseFunctions {
  static Future<String> resetRanking(String userId) async {
    String result = "";
    try {
      final dynamic response = await CloudFunctions.instance.call(
          functionName: "resetRanking", parameters: {"resetUserId": userId});
      result = response["result"];
    } on CloudFunctionsException catch (e) {
      print("caught firebase functions exception");
      print(e.code);
      print(e.message);
      print(e.details);
    } catch (e) {
      print("caught generic exception");
      print(e);
    }

    return result;
  }
}
