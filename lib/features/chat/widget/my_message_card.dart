import 'dart:developer';

import 'package:chat_app/common/enum/message_enum.dart';
import 'package:chat_app/features/chat/widget/display_message.dart';
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../../colors.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum messageEnum;
  final VoidCallback onLeftSwipe;
  final String repliedText;
  final String userName;
  final MessageEnum repliedMessageType;

  const MyMessageCard(
      {Key? key,
      required this.message,
      required this.date,
      required this.messageEnum,
      required this.onLeftSwipe,
      required this.repliedText,
      required this.userName,
      required this.repliedMessageType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isReplaying = repliedText.isNotEmpty;
    log('Replay data $isReplaying');
    return SwipeTo(
      onLeftSwipe: onLeftSwipe,
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 45, minWidth: 120),
          child: Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: messageColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                    padding: EdgeInsets.only(
                      left: messageEnum != MessageEnum.text ? 0 : 10,
                      right: messageEnum != MessageEnum.text ? 0 : 30,
                      top: messageEnum != MessageEnum.text ? 0 : 5,
                      bottom: messageEnum != MessageEnum.text ? 0 : 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isReplaying) ...[
                          Text(
                            userName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            color: appBarColor.withOpacity(0.7),
                            padding:const EdgeInsets.all(10),
                            child: DisplayMessage(
                                message: repliedText,
                                messageEnum: repliedMessageType),
                          )
                        ],
                        DisplayMessage(
                            message: message, messageEnum: messageEnum),
                      ],
                    )),
                Positioned(
                  bottom: 4,
                  right: 10,
                  child: Row(
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white60,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Icon(
                        Icons.done_all,
                        size: 20,
                        color: Colors.white60,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
