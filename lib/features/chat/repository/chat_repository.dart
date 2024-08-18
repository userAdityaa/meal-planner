import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_meal_planner/core/constants/firebase_constants.dart';
import 'package:flutter_meal_planner/core/provider/firebase_provider.dart';
import 'package:flutter_meal_planner/models/chat_model.dart';
import 'package:flutter_meal_planner/models/message_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
    firestore: ref.watch(firebaseFirestoreProvider),
  ),
);

class ChatRepository {
  final FirebaseFirestore _firestore;

  ChatRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _chats =>
      _firestore.collection(FirebaseConstants.chatCollection);

  String generateChatId(String uid1, String uid2) {
    List uIds = [uid1, uid2];
    uIds.sort();
    String chatId = uIds.fold("", (id, uid) => "$id$uid");
    return chatId;
  }

  void createChat(String uid1, String uid2) async {
    try {
      final chatID = generateChatId(uid1, uid2);
      final chatDoc = await _chats.doc(chatID).get();
      if (chatDoc.exists) {
        await _chats.doc(chatID).update({
          'participants': FieldValue.arrayUnion([uid1, uid2])
        });
        return;
      }
      final chat =
          ChatModel(id: chatID, participants: [uid1, uid2], messages: []);
      await _chats.doc(chatID).set(chat.toMap());
      return;
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> sendChatMessages(
      String uid1, String uid2, MessageModel message) async {
    String chatID = generateChatId(uid1, uid2);
    final chatDoc = _chats.doc(chatID);
    chatDoc.update({
      'messages': FieldValue.arrayUnion([message.toMap()])
    });
  }

  Stream<ChatModel> getChatData(String uid1, String uid2) {
    String chatID = generateChatId(uid1, uid2);

    return _chats.doc(chatID).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return ChatModel.fromMap(snapshot.data() as Map<String, dynamic>);
      } else {
        throw Exception('Chat document not found');
      }
    });
  }
}
