import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meal_planner/features/auth/controllers/auth_controller.dart';
import 'package:flutter_meal_planner/features/chat/controllers/chat_controller.dart';
import 'package:flutter_meal_planner/models/chat_model.dart';
import 'package:flutter_meal_planner/models/message_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ConversationPage extends ConsumerStatefulWidget {
  final personalChat;
  const ConversationPage({super.key, required this.personalChat});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConversationPageState();
}

class _ConversationPageState extends ConsumerState<ConversationPage> {
  ChatUser? currentUser, otherUser;

  @override
  void initState() {
    super.initState();
    currentUser = ChatUser(
        id: ref.read(userProvider)!.uid,
        firstName: ref.read(userProvider)!.name);
    otherUser = ChatUser(
        id: widget.personalChat['uid'], firstName: widget.personalChat['name']);
    // print(otherUser!.firstName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 60,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(widget.personalChat['name']),
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: StreamBuilder(
            stream: ref
                .watch(chatControllerProvider.notifier)
                .getChatData(currentUser!.id, otherUser!.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No data available'));
              } else {
                ChatModel? chat = snapshot.data as ChatModel?;
                List<ChatMessage> messages = [];
                if (chat != null && chat.messages != null) {
                  messages = _generateChatMessagesList(chat.messages);
                }
                return DashChat(
                  messageOptions: const MessageOptions(
                    showOtherUsersAvatar: false,
                    showTime: true,
                  ),
                  inputOptions: InputOptions(
                    alwaysShowSend: true,
                    trailing: [_mediaMessageButton()],
                  ),
                  currentUser: currentUser!,
                  onSend: _sendMessages,
                  messages: messages,
                );
              }
            }),
      ),
    );
  }

  Future<void> _sendMessages(ChatMessage chatMessage) async {
    String AIChat = "";
    bool isAIResponseReceived = false;

    // Send the user's message
    MessageModel userMessage = MessageModel(
      senderID: currentUser!.id,
      content: chatMessage.text,
      type:
          MessageType.Text.toString().split('.').last, // Convert enum to string
      sentAt: Timestamp.fromDate(
          chatMessage.createdAt), // Convert DateTime to Timestamp
    );

    await ref
        .read(chatControllerProvider.notifier)
        .sendChatMessages(currentUser!.id, otherUser!.id, userMessage);

    if (otherUser!.firstName == 'container') {
      final uri = Uri.parse('http://localhost:8000/chatUser');
      final response = await http.post(uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'message': chatMessage.text}));

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        AIChat = responseBody['fulfillmentText'];
        isAIResponseReceived = true;
        print("AI Response Success: $AIChat");
      } else {
        print('Failed to send message to the server: ${response.body}');
      }
    }

    // If the AI response was received, add it to the chat
    if (isAIResponseReceived) {
      MessageModel aiMessage = MessageModel(
        senderID: otherUser!.id,
        content: AIChat,
        type: MessageType.Text.toString()
            .split('.')
            .last, // Convert enum to string
        sentAt: Timestamp.fromDate(
            DateTime.now()), // Use current time for AI response
      );

      await ref
          .read(chatControllerProvider.notifier)
          .sendChatMessages(currentUser!.id, otherUser!.id, aiMessage);
    }
  }

  // Future<void> _sendMessages(ChatMessage chatMessage) async {
  //   String AIChat = "";
  //   if (otherUser!.firstName == 'container') {
  //     final uri = Uri.parse('http://localhost:8000/chatUser');
  //     final response = await http.post(uri,
  //         headers: {'Content-Type': 'application/json'},
  //         body: jsonEncode({'message': chatMessage.text}));
  //     if (response.statusCode == 200) {
  //       // AIChat = response.body;
  //       // print("Success");
  //       final responseBody = jsonDecode(response.body);

  //       // Extract the `fulfillmentText`
  //       AIChat = responseBody['fulfillmentText'];

  //       // Use the `fulfillmentText` as needed
  //       // print('Fulfillment Text: $fulfillmentText');
  //       print("Sucess");
  //     } else {
  //       print('Failed to send message to the server: ${response.body}');
  //     }
  //   }
  //   MessageModel message = MessageModel(
  //     senderID: currentUser!.id,
  //     content: chatMessage.text,
  //     type:
  //         MessageType.Text.toString().split('.').last, // Convert enum to string
  //     sentAt: Timestamp.fromDate(
  //         chatMessage.createdAt), // Convert DateTime to Timestamp
  //   );

  //   print(message);

  //   await ref
  //       .read(chatControllerProvider.notifier)
  //       .sendChatMessages(currentUser!.id, otherUser!.id, message);

  //   if (AIChat.isNotEmpty) {
  //     MessageModel aiMessage = MessageModel(
  //       senderID: otherUser!.id,
  //       content: AIChat,
  //       type: MessageType.Text.toString()
  //           .split('.')
  //           .last, // Convert enum to string
  //       sentAt: Timestamp.fromDate(chatMessage.createdAt),
  //     );

  //     // Add the AI message to the chat
  //     await ref
  //         .read(chatControllerProvider.notifier)
  //         .sendChatMessages(currentUser!.id, otherUser!.id, aiMessage);
  //   }
  // }

  List<ChatMessage> _generateChatMessagesList(List<MessageModel> messages) {
    List<ChatMessage> chatMessages = messages
        .map((msg) => ChatMessage(
            user: msg.senderID == currentUser!.id ? currentUser! : otherUser!,
            text: msg.content!,
            createdAt: msg.sentAt!.toDate()))
        .toList();

    chatMessages.sort((a, b) {
      return b.createdAt.compareTo(a.createdAt);
    });
    return chatMessages;
  }

  Widget _mediaMessageButton() {
    return IconButton(
      icon: Icon(Icons.image, color: Theme.of(context).colorScheme.primary),
      onPressed: () async {
        final _imagePicker = ImagePicker();
        var image = await _imagePicker.pickImage(source: ImageSource.gallery);
        if (image == null) {
          return;
        }
        // Add media message functionality here
      },
    );
  }
}
