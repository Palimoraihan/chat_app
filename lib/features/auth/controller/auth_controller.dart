import 'dart:developer';
import 'dart:io';

import 'package:chat_app/features/auth/repository/auth_repository.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider = Provider((ref) {
  final authRepositoryRef = ref.watch(authRepoProvider);
  return AuthController(authRepository: authRepositoryRef, ref: ref);
});

final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController({required this.ref, required this.authRepository});
  void signwithPhone(BuildContext context, String phoneNum) {
    authRepository.signPhoneNum(context, phoneNum);
  }

  void verifyOtp(BuildContext context, String veryfId, String userOtp) {
    authRepository.veryfiOtp(
      context: context,
      verifId: veryfId,
      userOtp: userOtp,
    );
  }

  void saveUserData(BuildContext context, String name, File? profilePick) {
    authRepository.saveUserData(
      name: name,
      profilePic: profilePick,
      ref: ref,
      context: context,
    );
  }

  Future<UserModel?> getUserData() async {
    UserModel? userMod = await authRepository.getCurrentUser();
    log('Nama Out User Data From Mai : ${userMod?.name}');
    // UserModel? userMod;
    // if (userMod == null) {
    //   userMod = null;

    // } else {
    //   userMod = await authRepository.getCurrentUser();

    // }
    return userMod;
  }

  Stream<UserModel> userDataById(
    String userId,
  ) {
    return authRepository.userData(userId);
  }

  void userPhoneStatus(bool isOnline) {
    authRepository.userPhoneStatus(isOnline);
  }
}
