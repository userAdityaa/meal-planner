import 'package:flutter_meal_planner/features/chat/repository/chat_repository.dart';
import 'package:flutter_meal_planner/models/message_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatControllerProvider = StateNotifierProvider<ChatController, bool>(
  (ref) => ChatController(
    chatRepository: ref.watch(chatRepositoryProvider),
    ref: ref,
  ),
);

class ChatController extends StateNotifier<bool> {
  final ChatRepository _chatRepository;
  final Ref _ref;

  ChatController({required ChatRepository chatRepository, required Ref ref})
      : _chatRepository = chatRepository,
        _ref = ref,
        super(false);

  String generateChatId(String uid1, String uid2) {
    return _chatRepository.generateChatId(uid1, uid2);
  }

  void createChat(String uid1, String uid2) {
    return _chatRepository.createChat(uid1, uid2);
  }

  Future<void> sendChatMessages(
      String uid1, String uid2, MessageModel message) async {
    return _chatRepository.sendChatMessages(uid1, uid2, message);
  }

  Stream getChatData(String uid1, String uid2) {
    return _chatRepository.getChatData(uid1, uid2);
  }
}
