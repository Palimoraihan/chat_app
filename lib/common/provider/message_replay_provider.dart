import 'package:chat_app/common/enum/message_enum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageReplay {
  final String message;
  final bool isMe;
  final MessageEnum messageEnum;

  MessageReplay(this.message, this.isMe, this.messageEnum);
}

final messageReplayProvider = StateProvider<MessageReplay?>((ref) => null);
