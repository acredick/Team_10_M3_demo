import 'package:DormDash/pages/shared/user_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../shared/user_util.dart';

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
          .collection('messages')
          .doc("Begin of conversation.")
          .set({'message': "Begin of conversation."});

    } catch (e) {
      print("Error opening new chat: ${e}");
    }
  }

  static Future<void> setDelivererInfo() async {
    try {
      await _staticFirestore
          .collection('chats')
          .doc(_chatID)
          .update({'delivererID': UserUtils.getEmail()});

      await _staticFirestore
          .collection('chats')
          .doc(_chatID)
          .update({'delivererFirstName': UserUtils.getFirstName()});

    } catch (e) {
      print("Failed to set user1: $e");
    }
  }

  static Future<void> addMessage(
    String senderID,
    String messageText,
  ) async {
    try {
      await _staticFirestore
          .collection('chats')
          .doc(_chatID)
          .collection('messages')
          .add({
            // Add a new message
            'senderID': senderID,
            'text': messageText,
            'timestamp': FieldValue.serverTimestamp(), // Store the time sent
          });

      print("Message added successfully!");
    } catch (e) {
      print("Failed to add message: $e");
    }
  }
}
