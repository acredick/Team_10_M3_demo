import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import '../../widgets/chat_manager.dart';
import '../../widgets/user_util.dart';
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
      home: DelivererChatScreen(chatID: 'sample-chat-id'),
    );
  }
}

class DelivererChatScreen extends StatefulWidget {
  final String chatID;

  const DelivererChatScreen({super.key, required this.chatID});

  @override
  State<DelivererChatScreen> createState() => _DelivererChatScreenState();
}

class _DelivererChatScreenState extends State<DelivererChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() async {
    CollectionReference messagesRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatID)
        .collection('messages');

    QuerySnapshot querySnapshot = await messagesRef.orderBy('timestamp').get();

    setState(() {
      _messages.clear();
      for (var doc in querySnapshot.docs) {
        Timestamp? timestamp = doc['timestamp'] as Timestamp?;
        String formattedTime = timestamp != null
            ? DateFormat('h:mm a').format(timestamp.toDate()) // Format time
            : 'Unknown Time';

        _messages.add({
          'text': doc['text'],
          'senderType': doc['senderType'],
          'time': formattedTime, // Store formatted time
        });
      }
    });

    _scrollToBottom();
  }

  void _sendMessage(String messageText) {
    if (messageText.isNotEmpty) {
      Timestamp timestamp = Timestamp.now();

      setState(() {
        _messages.add({
          'text': messageText,
          'senderType': 'deliverer',
          'time': DateFormat('h:mm a').format(timestamp.toDate()),
        });
        _controller.clear();
      });

      ChatManager.addMessage(
          widget.chatID, UserUtils.getEmail(), "deliverer", messageText);
    }
    FocusScope.of(context).unfocus();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
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
        title: const Text('Chat with Customer'),
        backgroundColor: const Color(0xFFDCB347), // Gold color
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                var message = _messages[index];
                bool isSenderDeliverer = message['senderType'] == 'deliverer';

                return Align(
                  alignment:
                  isSenderDeliverer ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: const EdgeInsets.fromLTRB(7,5,7,5),
                    decoration: BoxDecoration(
                      color: isSenderDeliverer
                          ? const Color(0xFFDCB347)
                          : Colors.purple[700],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['text'],
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          message['time'], // Display formatted time
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12),
                        ),
                      ],
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
