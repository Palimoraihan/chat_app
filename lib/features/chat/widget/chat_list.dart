import 'dart:developer';

import 'package:chat_app/common/enum/message_enum.dart';
import 'package:chat_app/common/provider/message_replay_provider.dart';
import 'package:chat_app/common/widget/loader.dart';
import 'package:chat_app/features/chat/controller/chat_controller.dart';
import 'package:chat_app/model/message_modeel.dart';
import 'package:chat_app/features/chat/widget/my_message_card.dart';
import 'package:chat_app/features/chat/widget/sender_message_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChatList extends ConsumerStatefulWidget {
  final String reciverUserId;
  const ChatList({super.key, required this.reciverUserId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void onMessageSwipe(
    String message,
    bool isMe,
    MessageEnum messageEnum,
  ) {
    ref
        .read(messageReplayProvider.state)
        .update((state) => MessageReplay(message, isMe, messageEnum));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MessageModel>>(
        stream: ref.read(chatController).chatStream(widget.reciverUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoaderWidget();
          }
          SchedulerBinding.instance.addPostFrameCallback((_) {
            scrollController.jumpTo(scrollController.position.maxScrollExtent);
          });
          return snapshot.data!.isNotEmpty
              ? ListView.builder(
                  controller: scrollController,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final messageData = snapshot.data![index];
                    log(messageData.type.type);
                    log(messageData.repliedMessage);
                    var timeSend = DateFormat.Hm().format(messageData.timeSend);
                    if (messageData.senderId ==
                        FirebaseAuth.instance.currentUser!.uid) {
                      return MyMessageCard(
                        message: messageData.text,
                        date: timeSend,
                        messageEnum: messageData.type,
                        repliedText: messageData.repliedMessage,
                        userName: messageData.repliedTo,
                        repliedMessageType: messageData.replayMessageType,
                        onLeftSwipe: () => onMessageSwipe(messageData.text, true, messageData.type),
                      );
                    }
                    return SenderMessageCard(
                      message: messageData.text,
                      date: timeSend,
                      messageEnum: messageData.type,
                      repliedText: messageData.repliedMessage,
                      userName: messageData.repliedTo,
                      repliedMessageType: messageData.replayMessageType,
                      onRighSwipe: () => onMessageSwipe(
                          messageData.text, false, messageData.type),
                    );
                  },
                )
              : SizedBox();
        });
  }
}
