import '../models/chat_message.dart';

abstract class ChatRepository {
  List<ChatMessage> getMessages();
  void addMessage(ChatMessage message);

  Future<void> sendMessage(ChatMessage newMessage) async {}
}
