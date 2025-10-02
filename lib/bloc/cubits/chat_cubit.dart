import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/chat_message.dart';
import '../../data/repositories/chat_repository.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../state/chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial()) {
    final ChatRepository repository = ChatRepositoryImpl();
    final List<ChatMessage> messages = repository.getMessages();
    emit(ChatLoaded(messages));
  }

  Future<void> loadMessages() async {
    emit(ChatLoading());
    try {} catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}
