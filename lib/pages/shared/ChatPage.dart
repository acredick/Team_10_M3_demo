import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../shared/user_util.dart';
import '/pages/customer_side/customer_chat.dart';
import '/pages/deliverer_side/deliverer-chat.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late Stream<QuerySnapshot> chatStream;
  String currentUserID = UserUtils.getEmail();

  @override
  void initState() {
    super.initState();
    chatStream = FirebaseFirestore.instance
        .collection('chats')
        .where('customerID', isEqualTo: currentUserID)
        .snapshots();
  }

  Future<String> getLastMessage(String chatID) async {
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
        return querySnapshot.docs.first['text'] ?? 'No message available';
      } else {
        return 'No messages yet';
      }
    } catch (e) {
      return 'Error retrieving message';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Conversations"),
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

                  return ListTile(
                    title: Text('Chat with $partner'),
                    subtitle: Text(lastMessage),
                    onTap: () {
                      if (UserUtils.getUserType() == "deliverer") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DelivererChatScreen(chatID: chatID),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomerChatScreen(chatID: chatID),
                          ),
                        );
                      }


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
