import 'package:flutter/material.dart';
import '/pages/shared/chat_manager.dart';
import '../shared/user_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CustomerChatScreen(chatID: 'sample-chat-id'),
    );
  }
}

class CustomerChatScreen extends StatefulWidget {
  final String chatID;

  const CustomerChatScreen({super.key, required this.chatID});

  @override
  State<CustomerChatScreen> createState() => _CustomerChatScreenState();
}

class _CustomerChatScreenState extends State<CustomerChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() async {
    // Fetch messages from the Firestore collection for the given chatID
    CollectionReference messagesRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatID)
        .collection('messages');

    // Get the messages ordered by timestamp in ascending order
    QuerySnapshot querySnapshot = await messagesRef
        .orderBy('timestamp')  // Implicitly sorts by ascending order
        .get();

    setState(() {
      // Populate the _messages list with the fetched message text
      _messages.clear(); // Clear existing messages (in case of a chat reload)
      for (var doc in querySnapshot.docs) {
        _messages.add(doc['text']);
      }
    });
  }

  void _sendMessage(String messageText) {
    if (messageText.isNotEmpty) {
      setState(() {
        _messages.insert(0, messageText);
        _controller.clear();
      });
      ChatManager.addMessage(widget.chatID, UserUtils.getEmail(), "customer", messageText);
    }
    FocusScope.of(context).unfocus();
  }

  void _onSendTap() {
    String messageText = _controller.text.trim();
    if (messageText.isNotEmpty) {
      _sendMessage(messageText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Dasher'),
        backgroundColor: const Color(0xFFDCB347),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.purple[700],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _messages[index],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.purple[700]),
                  onPressed: _onSendTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
