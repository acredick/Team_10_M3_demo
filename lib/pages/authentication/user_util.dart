// saves snapshot of user info on login

import 'package:firebase_auth/firebase_auth.dart';

class UserUtils {
  static late final fullName;
  static late final email;
  static late final userSnapshot;

  static void saveSnapshot(User? user) {
    userSnapshot = user;
    String displayName = user?.displayName ?? '';
    List<String> parts = displayName.split(", ");

    String lastName = parts[0];
    String firstAndMiddle = parts[1];

    fullName = "$firstAndMiddle $lastName";

    email = user?.email ?? '';

  }

  static String getFullName() {
    return fullName;
  }

  static String getEmail() {
    return email;
  }
}
