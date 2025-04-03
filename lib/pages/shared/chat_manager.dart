import 'package:DormDash/pages/shared/user_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../shared/user_util.dart';
import '/pages/shared/order_manager.dart';

class ChatManager {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseFirestore _staticFirestore = FirebaseFirestore.instance;
  static final ChatManager _instance = ChatManager._internal();
  static String? _chatID;
  static String? delivererID;
  static String? customerID;

  ChatManager._internal();

  factory ChatManager() {
    return _instance;
  }

  static void generateChatID() {
    final Uuid _uuid = Uuid();
    _chatID = _uuid.v4();
  }

  static void setChatID(String id) {
    _chatID = id;
  }

  static Future<void> openChat() async {
    try {
      await _staticFirestore.collection('chats').doc(_chatID).set({
        'createdAt': FieldValue.serverTimestamp(),
      });

      await _staticFirestore
          .collection('chats')
          .doc(_chatID)
          .update({'customerID': UserUtils.getEmail()});

      await _staticFirestore
          .collection('chats')
          .doc(_chatID)
          .update({'customerFirstName': UserUtils.getFirstName()});

      await _staticFirestore
          .collection('chats')
          .doc(_chatID)
          .update({'chatID': UserUtils.getFirstName()});

      await _staticFirestore
          .collection('chats')
          .doc(_chatID)
          .collection('messages')
          .doc("Begin of conversation.")
          .set({'message': "Begin of conversation."});
    } catch (e) {
      print("Error opening new chat: ${e}");
    }
  }

  static Future<void> setDelivererInfo() async {
    try {
      if (_chatID == null) {
        print("Error: _chatID is null. Cannot set deliverer info.");
        return;
      }

      print("Setting deliverer info for chatID: $_chatID");

      // Use _chatID as the document ID
      await _staticFirestore.collection('chats').doc(_chatID).set({
        'delivererID': UserUtils.getEmail(),
        'delivererFirstName': UserUtils.getFirstName(),
      }, SetOptions(merge: true)); // Merge to prevent overwriting other fields

      print("Deliverer info set successfully for chat ID: $_chatID");
    } catch (e) {
      print("Failed to set deliverer info: $e");
    }
  }

  static String getRecentChatID() {
    if (_chatID == null) {
      return "";
    }
    else {
      return _chatID!;
    }
  }

  static Future<void> addMessage(
      String chatID,
    String senderID,
    String senderType,
    String messageText,
  ) async {
    try {
      await _staticFirestore
          .collection('chats')
          .doc(chatID)
          .collection('messages')
          .add({
            // Add a new message
            'senderID': senderID,
            'text': messageText,
            'timestamp': FieldValue.serverTimestamp(), // Store the time sent
            'senderType': senderType
          });

      print("Message added successfully!");
    } catch (e) {
      print("Failed to add message: $e");
    }
  }
}
