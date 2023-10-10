import 'dart:developer';
import 'dart:io';

import 'package:chat_app/common/repositories/common_firebase_storage_repo.dart';
import 'package:chat_app/common/utils/utils.dart';
import 'package:chat_app/features/auth/page/otp_page.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/screens/mobile_layout_screen.dart';
import 'package:chat_app/screens/user_information_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepoProvider = Provider(
  (ref) => AuthRepository(
      auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance),
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  AuthRepository({required this.auth, required this.firestore});

  Future<UserModel?> getCurrentUser() async {
    var userData =
        await firestore.collection('user').doc(auth.currentUser!.uid).get();
    UserModel? userMod;
    if (userData.data() != null) {
      userMod = UserModel.fromMap(userData.data()!);
      return userMod;
    } else {
      return null;
    }
  }

  Future<void> signPhoneNum(BuildContext context, String phoneNum) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNum,
        verificationCompleted: (phoneAuthCredential) async {
          await auth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (error) {
          log('${error.message}');
        },
        codeSent: (verificationId, forceResendingToken) {
          Navigator.of(context)
              .pushNamed(OtpPage.routeName, arguments: verificationId);
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseException catch (e) {
      showSnacbar(
        ctx: context,
        content: e.toString(),
      );
    }
  }

  Future<void> veryfiOtp(
      {required BuildContext context,
      required String verifId,
      required String userOtp}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verifId, smsCode: userOtp);
      await auth.signInWithCredential(credential);
      UserModel? userMod = await getCurrentUser();
      if (userMod!.uid != auth.currentUser!.uid || userMod.uid.isEmpty) {
        Navigator.pushNamedAndRemoveUntil(
            context, UserInformationScreen.routeName, (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => MobileLayoutScreen(),
            ),
            (route) => false);
      }
    } on FirebaseException catch (e) {
      showSnacbar(
        ctx: context,
        content: e.toString(),
      );
    }
  }

  void saveUserData(
      {required String name,
      required File? profilePic,
      required ProviderRef ref,
      required BuildContext context}) async {
    try {
      String uid = auth.currentUser!.uid;
      String defImage =
          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';
      if (profilePic != null) {
        defImage = await ref
            .read(firebaseStrorageRepo)
            .storeFileToFirebase('profilePick/$uid', profilePic);
      }
      var user = UserModel(
          name: name,
          uid: uid,
          profilePick: defImage,
          isOnline: true,
          phoneNum: auth.currentUser!.phoneNumber!,
          groupId: []);
      log('${user.toMap()}');
      await firestore.collection('user').doc(uid).set(user.toMap());
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MobileLayoutScreen(),
          ),
          (route) => false);
    } catch (e) {
      showSnacbar(ctx: context, content: 'Failed add your data');
    }
  }

  Stream<UserModel> userData(String userId) {
    var userInFireStor = firestore.collection('user').doc(userId);
    return userInFireStor.snapshots().map(
          (event) => UserModel.fromMap(event.data()!),
        );
  }

  void userPhoneStatus(bool isOnline) async {
    await firestore
        .collection('user')
        .doc(auth.currentUser!.uid)
        .update({'isOnline': isOnline});
  }
}
