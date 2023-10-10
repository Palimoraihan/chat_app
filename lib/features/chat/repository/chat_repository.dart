import 'dart:io';

import 'package:chat_app/common/enum/message_enum.dart';
import 'package:chat_app/common/provider/message_replay_provider.dart';
import 'package:chat_app/common/repositories/common_firebase_storage_repo.dart';
import 'package:chat_app/common/utils/utils.dart';
import 'package:chat_app/model/chat_model.dart';
import 'package:chat_app/model/message_modeel.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final chatRepoProvider = Provider(
  (ref) => ChatRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class ChatRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  ChatRepository({required this.auth, required this.firestore});

  Stream<List<MessageModel>> getMessageStream(String reciverUserId) {
    return firestore
        .collection('user')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(reciverUserId)
        .collection('message')
        .orderBy('timeSend')
        .snapshots()
        .map((event) {
      List<MessageModel> _messages = [];
      for (var doc in event.docs) {
        _messages.add(MessageModel.fromMap(doc.data()));
      }
      return _messages;
    });
  }

  Stream<List<ChatContact>> fetchChatContacts() {
    return firestore
        .collection('user')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var doc in event.docs) {
        var chatContact = ChatContact.fromMap(doc.data());
        var userData =
            await firestore.collection('user').doc(chatContact.contactId).get();
        var user = UserModel.fromMap(userData.data()!);
        contacts.add(
          ChatContact(
            name: user.name,
            profilePic: user.profilePick,
            contactId: chatContact.contactId,
            timeSend: chatContact.timeSend,
            lastMessage: chatContact.lastMessage,
          ),
        );
      }
      return contacts;
    });
  }

  void _saveDataToContactSubCollection(
      UserModel senderUserData,
      UserModel recviverUserData,
      String text,
      DateTime timeSend,
      String reciverUserId) async {
    //FOR USER RECIVER
    var reciverChatContact = ChatContact(
      name: senderUserData.name,
      profilePic: senderUserData.profilePick,
      contactId: senderUserData.uid,
      timeSend: timeSend,
      lastMessage: text,
    );
    await firestore
        .collection('user')
        .doc(reciverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(
          reciverChatContact.toMap(),
        );
    // FOR OWN CHAT
    var senderChatContact = ChatContact(
      name: recviverUserData.name,
      profilePic: recviverUserData.profilePick,
      contactId: recviverUserData.uid,
      timeSend: timeSend,
      lastMessage: text,
    );
    await firestore
        .collection('user')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(reciverUserId)
        .set(
          senderChatContact.toMap(),
        );
  }

  void _saveMessageToMessageSubColection({
    required String reciverUserId,
    required String text,
    required DateTime timeSend,
    required String messageId,
    required String userName,
    required reciverUSerName,
    required MessageEnum messageType,
    required MessageReplay? messageReplay,
    required String senderUserName,
    required String reciverUserName,

  }) async {
    final message = MessageModel(
      senderId: auth.currentUser!.uid,
      reciverId: reciverUserId,
      text: text,
      type: messageType,
      timeSend: timeSend,
      messageId: messageId,
      isSend: false,
      repliedMessage: messageReplay == null ? '' : messageReplay.message,
      repliedTo: messageReplay == null ? '' : messageReplay.isMe? senderUserName:reciverUserName,
      replayMessageType:
          messageReplay == null ? MessageEnum.text : messageReplay.messageEnum,
    );
    await firestore
        .collection('user')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(reciverUserId)
        .collection('message')
        .doc(messageId)
        .set(message.toMap());

    await firestore
        .collection('user')
        .doc(reciverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('message')
        .doc(messageId)
        .set(message.toMap());
  }

  void sendMessage({
    required BuildContext context,
    required String text,
    required String reciveUserId,
    required UserModel senderUser,
    required MessageReplay? messageReplay
  }) async {
    try {
      var timeSend = DateTime.now();
      UserModel reciveUserData;
      var userDataMap =
          await firestore.collection('user').doc(reciveUserId).get();
      reciveUserData = UserModel.fromMap(userDataMap.data()!);
      var messageId = 'MES${Uuid().v1()}';
      _saveDataToContactSubCollection(
        senderUser,
        reciveUserData,
        text,
        timeSend,
        reciveUserId,
      );
      _saveMessageToMessageSubColection(
          reciverUserId: reciveUserId,
          text: text,
          timeSend: timeSend,
          messageId: messageId,
          userName: senderUser.name,
          reciverUSerName: reciveUserData.name,
          messageType: MessageEnum.text,
          messageReplay: messageReplay,
          reciverUserName: reciveUserData.name,
          senderUserName: senderUser.name,
          );

      // _saveDataToContactSubCollection();
    } catch (e) {
      showSnacbar(ctx: context, content: e.toString());
    }
  }

  void sendFileMessage(
      {required BuildContext context,
      required File file,
      required String reciverUserId,
      required UserModel senderUserData,
      required ProviderRef ref,
      required MessageEnum messageEnum,
    required MessageReplay? messageReplay}) async {
    try {
      var timeSend = DateTime.now();
      var messageId = 'MES${Uuid().v1()}';
      String imageUrl =
          await ref.read(firebaseStrorageRepo).storeFileToFirebase(
                'chat/${messageEnum.type}/${senderUserData.uid}/$reciverUserId/$messageId',
                file,
              );
      UserModel reciverUserModel;
      var userDataMap =
          await firestore.collection('user').doc(reciverUserId).get();
      reciverUserModel = UserModel.fromMap(userDataMap.data()!);
      String contactMesg;
      switch (messageEnum) {
        case MessageEnum.image:
          contactMesg = '📷 Photo';
          break;
        case MessageEnum.video:
          contactMesg = '📸 Video';
          break;
        case MessageEnum.audio:
          contactMesg = '🎶 Audio';
          break;
        case MessageEnum.gif:
          contactMesg = 'GIF';
          break;
        default:
          contactMesg = 'GIF';
      }

      _saveDataToContactSubCollection(senderUserData, reciverUserModel,
          contactMesg, timeSend, reciverUserId);
      _saveMessageToMessageSubColection(
        reciverUserId: reciverUserId,
        text: imageUrl,
        timeSend: timeSend,
        messageId: messageId,
        userName: senderUserData.name,
        reciverUSerName: reciverUserModel.name,
        messageType: messageEnum,
        messageReplay: messageReplay,
        reciverUserName: reciverUserModel.name,
        senderUserName: senderUserData.name,
      );
    } catch (e) {
      showSnacbar(ctx: context, content: e.toString());
    }
  }
}
