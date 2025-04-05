import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../shared/user_util.dart';
import '/pages/customer_side/customer_chat.dart';
import '/pages/deliverer_side/deliverer-chat.dart';
import '/pages/shared/status_manager.dart';
import '/pages/customer_side/disabled_customer_chat.dart';
import '/pages/deliverer_side/disabled_deliverer_chat.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late Stream<QuerySnapshot> chatStream;
  String currentUserID = UserUtils.getEmail();
  Map<String, String> chatStatuses = {}; // Store statuses for each chat
  Map<String, String> lastMessages = {}; // Store last messages for each chat

  @override
  void initState() {
    super.initState();
    String field = UserUtils.getUserType() == 'deliverer' ? 'delivererID' : 'customerID';

    chatStream = FirebaseFirestore.instance
        .collection('chats')
        .where(field, isEqualTo: currentUserID)
        .snapshots();
  }

  Future<void> fetchStatus(String chatID) async {
    if (!chatStatuses.containsKey(chatID)) {
      String status = await StatusManager.printStatus(true, chatID);
      setState(() {
        chatStatuses[chatID] = status;
      });
    }
  }

  Future<String> getLastMessage(String chatID) async {
    if (lastMessages.containsKey(chatID)) {
      return lastMessages[chatID] ?? 'No message available';
    }

    CollectionReference messagesRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatID)
        .collection('messages');

    try {
      QuerySnapshot querySnapshot = await messagesRef
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        lastMessages[chatID] = querySnapshot.docs.first['text'] ?? 'No message available';
      } else {
        lastMessages[chatID] = 'No messages yet';
      }
      return lastMessages[chatID] ?? 'No message available';
    } catch (e) {
      lastMessages[chatID] = 'Error retrieving message';
      return 'Error retrieving message';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conversations"),
        backgroundColor: Color(0xFFDCB347),
        automaticallyImplyLeading: false, // prevents back button
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: chatStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error loading chats"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No active conversations"));
          }

          var chats = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              var chat = chats[index];
              String chatID = chat.id;
              String partner;

              if (UserUtils.getUserType() == 'deliverer') {
                partner = chat['customerFirstName'] ?? 'Customer';
              } else {
                if ((chat.data() as Map<String, dynamic>)['delivererFirstName'] != null) {
                  partner = (chat.data() as Map<String, dynamic>)['delivererFirstName'];
                } else {
                  partner = 'Unknown Deliverer';
                }
              }

              // Fetching the status here only if it's not already fetched
              fetchStatus(chatID);

              return FutureBuilder<String>(
                future: getLastMessage(chatID),
                builder: (context, messageSnapshot) {
                  if (messageSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      title: Text('Chat with $partner'),
                      subtitle: Text('Loading last message...'),
                    );
                  }

                  if (messageSnapshot.hasError) {
                    return ListTile(
                      title: Text('Chat with $partner'),
                      subtitle: Text('Error loading last message'),
                    );
                  }

                  String lastMessage = messageSnapshot.data ?? 'No messages yet';
                  String status = chatStatuses[chatID] ?? 'Unknown status';

                  return Container(
                    color: status == "Completed" ? Colors.grey[300] : null,
                    child: ListTile(
                      title: RichText(
                        text: TextSpan(
                          text: 'Chat with $partner ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "  $status",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      subtitle: Text(lastMessage),
                      onTap: () {
                        if (UserUtils.getUserType() == "deliverer") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DisabledDelivererChatScreen(chatID: chatID),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DisabledCustomerChatScreen(chatID: chatID),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              );

            },
          );
        },
      ),
    );
  }
}
