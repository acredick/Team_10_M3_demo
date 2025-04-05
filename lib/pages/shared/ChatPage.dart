import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../shared/user_util.dart';
import '/pages/customer_side/customer_chat.dart';
import '/pages/deliverer_side/deliverer-chat.dart';
import '/pages/shared/status_manager.dart';
import '/pages/customer_side/disabled_customer_chat.dart';
import '/pages/deliverer_side/disabled_deliverer_chat.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late Stream<QuerySnapshot> chatStream;
  String currentUserID = UserUtils.getEmail();
  Map<String, String> lastMessages = {};
  Map<String, Timestamp> lastMessageTimestamps = {};

  @override
  void initState() {
    super.initState();
    String field = UserUtils.getUserType() == 'deliverer' ? 'delivererID' : 'customerID';

    chatStream = FirebaseFirestore.instance
        .collection('chats')
        .where(field, isEqualTo: currentUserID)
        .snapshots();
  }

  Future<Map<String, dynamic>> getLastMessageData(String chatID) async {
    if (lastMessages.containsKey(chatID) && lastMessageTimestamps.containsKey(chatID)) {
      return {
        'text': lastMessages[chatID],
        'timestamp': lastMessageTimestamps[chatID],
      };
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
        var doc = querySnapshot.docs.first;
        lastMessages[chatID] = doc['text'] ?? 'No message available';
        lastMessageTimestamps[chatID] = doc['timestamp'];
      } else {
        DocumentSnapshot chatDoc = await FirebaseFirestore.instance
            .collection('chats')
            .doc(chatID)
            .get();

        if (chatDoc.exists) {
          lastMessages[chatID] = 'No messages yet';
          lastMessageTimestamps[chatID] = chatDoc['createdAt'] ?? Timestamp(0, 0);
        } else {
          lastMessages[chatID] = 'Error retrieving chat data';
          lastMessageTimestamps[chatID] = Timestamp(0, 0);
        }
      }

      return {
        'text': lastMessages[chatID],
        'timestamp': lastMessageTimestamps[chatID],
      };
    } catch (e) {
      return {
        'text': 'Error retrieving message',
        'timestamp': Timestamp(0, 0),
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conversations"),
        backgroundColor: Color(0xFFDCB347),
        automaticallyImplyLeading: false,
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

          List<Map<String, dynamic>> chatDataList = chats.map((chat) {
            var data = chat.data() as Map<String, dynamic>;
            data['chatID'] = chat.id;
            data['timestamp'] = data['timestamp'] ?? Timestamp(0, 0);
            return data;
          }).toList();

          return FutureBuilder(
            future: Future.wait(chatDataList.map((chat) async {
              String chatID = chat['chatID'];
              String status = await StatusManager.printStatus(true, chatID);
              chat['status'] = status;
              return chat;
            })),
            builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> asyncSnapshot) {
              if (!asyncSnapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              List<Map<String, dynamic>> chatsWithStatus = asyncSnapshot.data!;

              chatsWithStatus.sort((a, b) {
                // sort by the status: non-completed orders should come first
                if (a['status'] != 'Complete' && b['status'] == 'Complete') return -1;
                if (a['status'] == 'Complete' && b['status'] != 'Complete') return 1;

                // sort by timestamp descending (newest first)
                Timestamp aTime = a['timestamp'] as Timestamp;
                Timestamp bTime = b['timestamp'] as Timestamp;
                return bTime.compareTo(aTime);
              });

              return ListView.builder(
                itemCount: chatsWithStatus.length,
                itemBuilder: (context, index) {
                  var chat = chatsWithStatus[index];
                  String chatID = chat['chatID'];
                  String status = chat['status'];
                  String partner = UserUtils.getUserType() == 'deliverer'
                      ? chat['customerFirstName'] ?? 'Customer'
                      : chat['delivererFirstName'] ?? 'Unknown Deliverer';

                  return FutureBuilder<Map<String, dynamic>>(
                    future: getLastMessageData(chatID),
                    builder: (context, messageSnapshot) {
                      String lastMessage = 'Loading...';
                      String formattedTime = '';
                      if (messageSnapshot.hasData) {
                        lastMessage = messageSnapshot.data!['text'];
                        Timestamp timestamp = messageSnapshot.data!['timestamp'];
                        DateTime dateTime = timestamp.toDate();
                        formattedTime = DateFormat('MMM d, h:mm a').format(dateTime);
                      } else if (messageSnapshot.hasError) {
                        lastMessage = 'Error retrieving message';
                      }

                      return Container(
                        color: status == "Complete" ? Colors.grey[300] : null,
                        child: ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Chat with $partner ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "  $status",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (formattedTime.isNotEmpty)
                                Text(
                                  formattedTime,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                            ],
                          ),
                          subtitle: Text(lastMessage),
                          onTap: () {
                            if (UserUtils.getUserType() == "deliverer") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DisabledDelivererChatScreen(chatID: chatID),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DisabledCustomerChatScreen(chatID: chatID),
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
          );

        },
      ),
    );
  }
}
