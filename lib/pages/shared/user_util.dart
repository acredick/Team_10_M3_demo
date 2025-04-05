// saves snapshot of user info on login

import 'package:firebase_auth/firebase_auth.dart';

class UserUtils {
  static late final fullName;
  static late final firstName;
  static late final lastName;
  static late final email;
  static late final userSnapshot;
  static var userType = "";

  static void saveSnapshot(User? user) {
    userSnapshot = user;
    String displayName = user?.displayName ?? '';
    List<String> parts = displayName.split(", ");

    lastName = parts[0];
    String firstAndMiddle = parts[1];

    List<String> nameParts = firstAndMiddle.split(" ");
    firstName = nameParts.isNotEmpty ? nameParts[0] : '';

    fullName = "$firstAndMiddle $lastName";

    email = user?.email ?? '';

  }

  static void setUserType(String type) {
    userType = type;
  }

  static String getFullName() {
    return fullName;
  }

  static String getFirstName() {
    return firstName;

  }

  static String getLastName() {
    return lastName;
  }

  static String getEmail() {
    return email;
  }

  static String getUserType() {
    return userType;
  }
}
