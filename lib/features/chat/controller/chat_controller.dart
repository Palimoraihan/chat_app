import 'dart:developer';
import 'dart:io';

import 'package:chat_app/common/enum/message_enum.dart';
import 'package:chat_app/common/provider/message_replay_provider.dart';
import 'package:chat_app/features/auth/controller/auth_controller.dart';
import 'package:chat_app/features/chat/repository/chat_repository.dart';
import 'package:chat_app/model/chat_model.dart';
import 'package:chat_app/model/message_modeel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatController = Provider((ref) {
  final chatRepository = ref.watch(chatRepoProvider);
  return ChatController(chatRepository: chatRepository, ref: ref);
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({required this.chatRepository, required this.ref});

  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.fetchChatContacts();
  }

  Stream<List<MessageModel>> chatStream(String reciverUser) {
    log(reciverUser);
    return chatRepository.getMessageStream(reciverUser);
  }

  void sendTextMessage(BuildContext context, String text, String reciveUserId) {
    final messageReplay = ref.read(messageReplayProvider);
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendMessage(
              context: context,
              text: text,
              reciveUserId: reciveUserId,
              senderUser: value!,
              messageReplay: messageReplay),
        );
    ref.read(messageReplayProvider.state).update((state) => null);
  }

  void sendFileMessage(
    BuildContext context,
    File file,
    String reciveUserId,
    MessageEnum messageEnum,
  ) {
    final messageReplay = ref.read(messageReplayProvider);
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendFileMessage(
            context: context,
            file: file,
            reciverUserId: reciveUserId,
            senderUserData: value!,
            messageEnum: messageEnum,
            ref: ref,
            messageReplay: messageReplay,
          ),
        );
    ref.read(messageReplayProvider.state).update((state) => null);
    
  }
}
