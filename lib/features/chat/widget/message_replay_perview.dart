import 'package:chat_app/common/provider/message_replay_provider.dart';
import 'package:chat_app/features/chat/widget/display_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageReplayPervie extends ConsumerWidget {
  const MessageReplayPervie({super.key});

  void cancelReplay(WidgetRef ref) {
    ref.read(messageReplayProvider.state).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReplay = ref.watch(messageReplayProvider);
    return Container(
      width: 350,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  messageReplay!.isMe ? 'Me' : 'Opposet',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                child: const Icon(Icons.close),
                onTap:()=> cancelReplay(ref),
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          DisplayMessage(message: messageReplay.message, messageEnum: messageReplay.messageEnum)
         ,
        ],
      ),
    );
  }
}
