import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../core/adaptive_size_extension.dart';
import '../bloc/cubits/chat_cubit.dart';
import '../bloc/state/chat_state.dart';
import '../core/constants/base_colors.dart';
import '../core/constants/bottom_bar.dart';
import '../core/constants/custom_app_bar.dart';
import '../core/constants/custom_background_with_gradient.dart';
import '../core/constants/grey_line.dart';
import '../data/models/chat_message.dart';

enum MessageStatus { sent, delivered, read, sending }

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) => switch (state) {
          ChatLoaded() => _buildChatContent(state),
          ChatError() => Center(child: Text('Ошибка: ${state.message}')),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
      bottomNavigationBar: BottomBar(currentScreen: context.widget),
    );
  }

  Widget _buildChatContent(ChatLoaded state) {
    return CustomBackgroundWithGradient(
      child: Column(
        children: [
          const CustomAppBar(label: "online assistance"),
          const GreyLine(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              itemCount: state.messages.length,
              itemBuilder: (context, index) {
                final message = state.messages[index];
                final previousMessage = index + 1 < state.messages.length
                    ? state.messages[index + 1]
                    : null;
                return ChatBubble(
                  message: message,
                  previousMessage: previousMessage,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final ChatMessage? previousMessage;

  const ChatBubble({super.key, required this.message, this.previousMessage});

  static final _timeFormat = DateFormat('HH:mm');
  static final _dateFormat = DateFormat('dd.MM.yyyy \'at\' HH.mm');

  bool get _isMe => message.isSentByUser;

  bool _isDifferentDay(DateTime? date1, DateTime date2) {
    if (date1 == null) return true;
    return date1.year != date2.year ||
        date1.month != date2.month ||
        date1.day != date2.day;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_shouldShowDateSeparator)
          _DateSeparator(timestamp: message.timestamp),
        _MessageBubbleRow(message: message, isMe: _isMe),
      ],
    );
  }

  bool get _shouldShowDateSeparator =>
      previousMessage == null ||
      _isDifferentDay(previousMessage?.timestamp, message.timestamp);
}

class _DateSeparator extends StatelessWidget {
  final DateTime timestamp;

  const _DateSeparator({required this.timestamp});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.adaptiveSize(8.0)),
      child: Text(
        DateFormat('dd.MM.yyyy \'at\' HH.mm').format(timestamp),
        style: context.adaptiveTextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: const Color.fromRGBO(151, 151, 151, 1),
        ),
      ),
    );
  }
}

class _MessageBubbleRow extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;

  const _MessageBubbleRow({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          alignment: Alignment.topRight,
          margin: EdgeInsets.only(bottom: context.adaptiveSize(28)),
          child: Stack(
            alignment: isMe ? Alignment.topRight : Alignment.topLeft,
            children: [
              _MessageContainer(message: message, isMe: isMe),
              _AvatarCircle(isMe: isMe),
            ],
          ),
        ),
      ],
    );
  }
}

class _MessageContainer extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;

  const _MessageContainer({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    final avatarSize = context.adaptiveSize(22);
    final horizontalMargin = EdgeInsets.only(
      top: avatarSize,
      left: isMe ? 0 : avatarSize,
      right: isMe ? avatarSize : 0,
    );

    return Container(
      alignment: Alignment.center,
      width: context.adaptiveSize(250),
      margin: horizontalMargin,
      padding: EdgeInsets.all(context.adaptiveSize(30)),
      decoration: BoxDecoration(
        color: isMe ? BaseColors.secondary : BaseColors.backgroundCircles,
        borderRadius: BorderRadius.circular(context.adaptiveSize(32)),
      ),
      child: Text(
        message.text,
        style: context.adaptiveTextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: isMe ? BaseColors.background : BaseColors.text,
        ),
      ),
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  final bool isMe;

  const _AvatarCircle({required this.isMe});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: context.adaptiveSize(22),
      backgroundImage: AssetImage(
        isMe
            ? 'assets/images/avatars/me.jpg'
            : 'assets/images/avatars/another.jpg',
      ),
    );
  }
}
