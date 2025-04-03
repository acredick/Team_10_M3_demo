import 'package:firebase_auth/firebase_auth.dart';

class UserUtils {
  static late final fullName;

  static void setName(User? user) {
    String displayName = user?.displayName ?? '';
    List<String> parts = displayName.split(", ");

    String lastName = parts[0];
    String firstAndMiddle = parts[1];

    fullName = "$firstAndMiddle $lastName";
  }

  static String getFullName() {
    return fullName;
  }
}
