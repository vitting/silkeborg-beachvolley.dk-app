import 'package:meta/meta.dart';

class EnrollmentExists {
  final bool emailExists;
  final int emailCount;
  final bool phoneExists;
  final int phoneCount;

  EnrollmentExists({@required this.emailExists, @required this.phoneExists, this.emailCount, this.phoneCount});
}