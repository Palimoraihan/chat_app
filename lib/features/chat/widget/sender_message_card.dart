import 'package:chat_app/features/chat/widget/display_message.dart';
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../../colors.dart';
import '../../../common/enum/message_enum.dart';

class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.messageEnum,
    required this.onRighSwipe,
    required this.repliedText,
    required this.userName,
    required this.repliedMessageType,
  }) : super(key: key);
  final String message;
  final String date;
  final MessageEnum messageEnum;
  final VoidCallback onRighSwipe;
  final String repliedText;
  final String userName;
  final MessageEnum repliedMessageType;

  @override
  Widget build(BuildContext context) {
    final bool isReplaying = repliedText.isNotEmpty;
    return SwipeTo(
      onRightSwipe: onRighSwipe,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: senderMessageColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                    padding: EdgeInsets.only(
                      left: messageEnum == MessageEnum.image ? 0 : 10,
                      right: messageEnum == MessageEnum.image ? 0 : 30,
                      top: messageEnum == MessageEnum.image ? 0 : 5,
                      bottom: messageEnum == MessageEnum.image ? 0 : 20,
                    ),
                    child: Column(
                      children: [
                        if (isReplaying) ...[
                          Text(
                            userName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            color: appBarColor,
                            padding: EdgeInsets.all(10),
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
                  bottom: 2,
                  right: 10,
                  child: Text(
                    date,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
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
