import 'package:uuid/uuid.dart';

class UuidUtils {
  static var uuid = Uuid();

  static String generate() {
    return uuid.v4();
  }
}
