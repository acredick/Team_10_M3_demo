// saves snapshot of user info on login
import 'package:DormDash/widgets/user_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'order_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserUtils {
  static final FirebaseFirestore _staticFirestore = FirebaseFirestore.instance;
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

  static Future<void> setProfile(String userType) async {
    try {
      String email = getEmail();
      DocumentReference userRef = _staticFirestore.collection("${userType}s").doc(email);
      DocumentSnapshot userSnapshot = await userRef.get();

      if (!userSnapshot.exists) {
        await userRef.set({
          'createdAt': FieldValue.serverTimestamp(),
        });

        await userRef.set({
          'firstName': firstName,
          'lastName': lastName,
        }, SetOptions(merge: true));

        await _staticFirestore
            .collection("${userType}s")
            .doc(getEmail())
            .collection('reviews_given')
            .add({
              'content': "",
              'timestamp': FieldValue.serverTimestamp(),
        });

        await _staticFirestore
            .collection("${userType}s")
            .doc(getEmail())
            .collection('ratings_given')
            .add({
              'rating': 5,
              'timestamp': FieldValue.serverTimestamp(),
        });

        await _staticFirestore
            .collection("${userType}s")
            .doc(getEmail())
            .collection('reviews_received')
            .add({
              'content': "",
              'timestamp': FieldValue.serverTimestamp(),
        });
        await _staticFirestore
            .collection("${userType}s")
            .doc(getEmail())
            .collection('ratings_received')
            .add({
              'rating': 5,
              'timestamp': FieldValue.serverTimestamp(),
        });
      } else {
        print("User already exists in the database.");
      }
    } catch (e) {
      print("Error setting user profile: $e");
    }
  }
}
