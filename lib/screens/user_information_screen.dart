import 'dart:io';

import 'package:chat_app/colors.dart';
import 'package:chat_app/common/utils/utils.dart';
import 'package:chat_app/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  static const String routeName = '/user-information';
  const UserInformationScreen({super.key});

  @override
  ConsumerState<UserInformationScreen> createState() =>
      _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final TextEditingController nameController = TextEditingController();
  File? image;
  @override
  void dispose() {
    nameController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void selectImage() async {
    image = await pickImageGalery(context);
    setState(() {});
  }

  void storeUserData() async {
    String name = nameController.text.trim();
    if (name.isNotEmpty) {
      ref.read(authControllerProvider).saveUserData(
            context,
            name,
            image,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sizeres = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                image == null
                    ? const CircleAvatar(
                        radius: 60,
                        backgroundColor: messageColor,
                        child: Icon(
                          Icons.person,
                          size: 100,
                          color: backgroundColor,
                        ),
                      )
                    : CircleAvatar(
                        radius: 60,
                        backgroundImage: FileImage(image!),
                      ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                      onPressed: selectImage,
                      icon: Icon(Icons.add_a_photo_rounded)),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  width: sizeres.width * 0.85,
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(hintText: 'Enter Name'),
                  ),
                ),
                IconButton(
                  onPressed: storeUserData,
                  icon: const Icon(Icons.done),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
