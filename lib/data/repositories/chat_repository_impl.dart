import '../models/chat_message.dart';
import 'chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final List<ChatMessage> _messages = [
    ChatMessage(
      text:
          'Hello! Here you can book apartments, rent a car or bike. Please, check the time zone! The answer may come a little later due to the time difference.',
      timestamp: DateTime.now().subtract(Duration(minutes: 10)),
      isSentByUser: false,
    ),
    ChatMessage(
      text:
          'Hi. Can I contact you if I want to rent a boat or take an excursion to the Favignana? I will arrive in Sicily on July 24 and want to pick up the car that I paid for at Palermo airport. The plane arrives at 16.40 from Moscow.',
      timestamp: DateTime.now().subtract(Duration(minutes: 5)),
      isSentByUser: true,
    ),
    ChatMessage(
      text:
          'Hi. Can I contact you if I want to rent a boat or take an excursion to the Favignana? I will arrive in Sicily on July 24 and want to pick up the car that I paid for at Palermo airport. The plane arrives at 16.40 from Moscow.',
      timestamp: DateTime.now(),
      isSentByUser: false,
    ),
    ChatMessage(
      text:
          'Hi. Can I contact you if I want to rent a boat or take an excursion to the Favignana? I will arrive in Sicily on July 24 and want to pick up the car that I paid for at Palermo airport. The plane arrives at 16.40 from Moscow.',
      timestamp: DateTime.now().subtract(Duration(minutes: 5)),
      isSentByUser: true,
    ),
    ChatMessage(
      text:
          'Hi. Can I contact you if I want to rent a boat or take an excursion to the Favignana? I will arrive in Sicily on July 24 and want to pick up the car that I paid for at Palermo airport. The plane arrives at 16.40 from Moscow.',
      timestamp: DateTime.now(),
      isSentByUser: false,
    ),
  ];

  @override
  List<ChatMessage> getMessages() {
    return _messages;
  }

  @override
  Future<void> addMessage(ChatMessage message) async {
    _messages.add(message);
  }

  @override
  Future<void> sendMessage(ChatMessage newMessage) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }
}
