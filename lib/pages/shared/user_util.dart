// saves snapshot of user info on login
import 'package:DormDash/pages/shared/user_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '/pages/shared/order_manager.dart';
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

      // Check if the user already exists
      DocumentSnapshot userSnapshot = await userRef.get();

      // Only proceed if the user document does not exist
      if (!userSnapshot.exists) {
        // Create the user document with the 'createdAt' timestamp
        await userRef.set({
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Set other user data
        await userRef.set({
          'firstName': firstName,
          'lastName': lastName,
        }, SetOptions(merge: true)); // Merge to avoid overwriting existing fields

        // Add a 'reviews' collection
        await userRef.collection('reviews').add({
          'content': "",
        });

        // Add a 'ratings' collection
        await userRef.collection('ratings').add({
          'rating': 5,
        });
      } else {
        print("User already exists in the database.");
      }
    } catch (e) {
      print("Error setting user profile: $e");
    }
  }
}
