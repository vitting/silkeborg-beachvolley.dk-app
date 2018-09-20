import 'package:uuid/uuid.dart';

class UuidHelpers {
  static String generateUuid() {
    Uuid _uuid = new Uuid(); 
    return _uuid.v4().toString();
  }
}