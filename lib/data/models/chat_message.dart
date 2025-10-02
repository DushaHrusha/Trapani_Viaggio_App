import '../../presentation/chat_screen.dart';

class ChatMessage {
  final String text;
  final DateTime timestamp;
  final bool isSentByUser;
  final MessageStatus status;

  ChatMessage({
    required this.text,
    required this.timestamp,
    required this.isSentByUser,
    this.status = MessageStatus.sent,
  });
}
