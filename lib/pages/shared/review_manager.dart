import 'package:DormDash/pages/shared/user_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '/pages/shared/order_manager.dart';

class ReviewManager {
  static final FirebaseFirestore _staticFirestore = FirebaseFirestore.instance;
  static final ReviewManager _instance = ReviewManager._internal();
  static String? delivererID;
  static String? customerID;

  ReviewManager._internal();

  factory ReviewManager() {
    return _instance;
  }

  static Future<void> addReview(
      String content,
      String senderID,
      String receiverID,
      bool isSenderCustomer,
      ) async {
    try {
      if (isSenderCustomer) {
        // give review to deliverer
        await _staticFirestore
            .collection('deliverers')
            .doc(receiverID)
            .collection('reviews_received')
            .add({
              'content': content,
              'sender': senderID,
              'timestamp': FieldValue.serverTimestamp(),
        });

        // add review to profile
        await _staticFirestore
            .collection('customers')
            .doc(senderID)
            .collection('reviews_given')
            .add({
          'content': content,
          'sender': senderID,
          'receiver': receiverID,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } else {
        // give review to customer
        await _staticFirestore
            .collection('customers')
            .doc(receiverID)
            .collection('reviews_received')
            .add({
          'content': content,
          'sender': senderID,
          'receiver': receiverID,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // add review to profile
        await _staticFirestore
            .collection('deliverers')
            .doc(senderID)
            .collection('reviews_given')
            .add({
          'content': content,
          'sender': senderID,
          'receiver': receiverID,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
      print("Review added successfully!");
    } catch (e) {
      print("Failed to add review: $e");
    }
  }

  static Future<void> addRating(
      int rating,
      String senderID,
      String receiverID,
      bool isSenderCustomer,
      ) async {
    try {
      if (isSenderCustomer) {
        // give rating to deliverer
        await _staticFirestore
            .collection('deliverers')
            .doc(receiverID)
            .collection('ratings_received')
            .add({
          'rating': rating,
          'sender': senderID,
          'receiver': receiverID,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // add rating to own profile
        await _staticFirestore
            .collection('customers')
            .doc(senderID)
            .collection('ratings_given')
            .add({
          'rating': rating,
          'sender': senderID,
          'receiver': receiverID,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } else {
        // give rating to customer
        await _staticFirestore
            .collection('customers')
            .doc(receiverID)
            .collection('ratings_received')
            .add({
          'rating': rating,
          'sender': senderID,
          'receiver': receiverID,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // add rating to own profile
        await _staticFirestore
            .collection('deliverers')
            .doc(senderID)
            .collection('ratings_given')
            .add({
          'rating': rating,
          'sender': senderID,
          'receiver': receiverID,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
      print("Message added successfully!");
    } catch (e) {
      print("Failed to add message: $e");
    }
  }
}
