import 'dart:developer';

import 'package:chat_app/common/utils/utils.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/features/chat/page/mobile_chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectContactRepoProvider = Provider(
  (ref) => SelectContactRepo(firestor: FirebaseFirestore.instance),
);

class SelectContactRepo {
  final FirebaseFirestore firestor;

  SelectContactRepo({required this.firestor});

  Future<List<Contact>> getContact() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      var userCollection = await firestor.collection('user').get();
      bool isFound = false;
      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        String contactSelect =
            selectedContact.phones[0].number.replaceAll(' ', '');
        log(contactSelect);
        if (contactSelect == userData.phoneNum) {
          isFound = true;
          Navigator.pushNamed(context, MobileChatPage.routeName, arguments: {
            'name': userData.name,
            'uid':userData.uid
          });
        }
      }
      if (!isFound) {
        showSnacbar(ctx: context, content: 'This Number not exist on this app');
      }
    } catch (e) {
      showSnacbar(ctx: context, content: e.toString());
    }
  }
}
