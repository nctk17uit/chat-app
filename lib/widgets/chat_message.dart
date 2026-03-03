
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/widgets/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
class ChatMessages extends StatefulWidget {
  const ChatMessages({super.key});

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {


  @override
  Widget build(BuildContext context) {
    final authenticatedUserId = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No messages found.'));
          }
          if (chatSnapshot.hasError) {
            return const Center(
              child: Text('An error occurred while loading messages.'),
            );
          }

          final loadedMessages = chatSnapshot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 40, left: 10, right: 10),
            reverse: true,
            itemCount: loadedMessages.length,
            itemBuilder: (ctx, index){
              final chatMessage = loadedMessages[index].data();
              final nextChatMessage = index + 1 < loadedMessages.length
                  ? loadedMessages[index + 1].data()
                  : null;
              final currentMessageUserId = loadedMessages[index]
                  .data()['userId'];
              final nextMessageUserId = nextChatMessage != null
                  ? nextChatMessage['userId']
                  : null;
              final nextUserIsSame = nextMessageUserId == currentMessageUserId;

              if (nextUserIsSame) {
                return MessageBubble.next(
                  message: chatMessage['text'],
                  isMe: authenticatedUserId.uid == currentMessageUserId,
                );
              } else {
                return MessageBubble.first(
                  message: chatMessage['text'],
                  isMe: authenticatedUserId.uid == currentMessageUserId,
                  userImage: loadedMessages[index].data()['userImage'],
                  username: loadedMessages[index].data()['username'],
                );
              }
            },
          );
        },
      ),
    );
  }
}
