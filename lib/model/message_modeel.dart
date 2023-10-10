
import 'package:chat_app/common/enum/message_enum.dart';

class MessageModel {
  final String senderId;
  final String reciverId;
  final String text;
  final MessageEnum type;
  final DateTime timeSend;
  final String messageId;
  final bool isSend;
  final String repliedMessage;
  final String repliedTo;
  final MessageEnum replayMessageType;

  MessageModel({
    required this.senderId,
    required this.reciverId,
    required this.text,
    required this.type,
    required this.timeSend,
    required this.messageId,
    required this.isSend,
    required this.repliedMessage,
    required this.repliedTo,
    required this.replayMessageType,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'reciverId': reciverId,
      'text': text,
      'type': type.type,
      'timeSend': timeSend.millisecondsSinceEpoch,
      'messageId': messageId,
      'isSend': isSend,
      'repliedMessage': repliedMessage,
      'repliedTo': repliedTo,
      'replayMessageType': replayMessageType.type,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map['senderId'] ?? '',
      reciverId: map['reciverId'] ?? '',
      text: map['text'] ?? '',
      type: (map['type']as String).toEnum(),
      timeSend: DateTime.fromMillisecondsSinceEpoch(map['timeSend']),
      messageId: map['messageId'] ?? '',
      isSend: map['isSend'] ?? false,
      repliedMessage: map['repliedMessage'] ?? '',
      repliedTo: map['repliedTo'] ?? '',
      replayMessageType: (map['replayMessageType']as String).toEnum(),
    );
  }

}
