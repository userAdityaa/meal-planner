import 'package:flutter/material.dart';
import 'package:flutter_meal_planner/features/auth/controllers/auth_controller.dart';
import 'package:flutter_meal_planner/features/chat/controllers/chat_controller.dart';
import 'package:flutter_meal_planner/features/chat/screens/convo_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  List<Map<String, dynamic>> chatUsers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final users =
          await ref.read(authControllerProvider.notifier).getAllUsers();
      setState(() {
        chatUsers = users;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      // Handle error appropriately here
      throw ('Error fetching users: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Messages",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),
              Expanded(
                child: ListView.builder(
                  itemCount: chatUsers.length,
                  itemBuilder: (context, index) {
                    final user = chatUsers[index];
                    return ListTile(
                      onTap: () {
                        ref.watch(chatControllerProvider.notifier).createChat(
                            ref.watch(userProvider)!.uid, user['uid']);
                        print("User id: " + user['uid']);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ConversationPage(personalChat: user)));
                      },
                      titleAlignment: ListTileTitleAlignment.top,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 0),
                      leading: const CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 30,
                      ), // Remove default padding
                      title: Text(user['name'] as String),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
