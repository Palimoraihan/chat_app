import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnacbar({required BuildContext ctx, required String content}) {
  ScaffoldMessenger.of(ctx).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

Future<File?> pickImageGalery(BuildContext context) async {
  File? image;
  try {
    final pickImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickImage != null) {
      image = File(pickImage.path);
    } else {
      showSnacbar(ctx: context, content: 'No Image Added');
    }
  } catch (e) {
    showSnacbar(ctx: context, content: e.toString());
  }
  return image;
}

Future<File?> pickVideoGalery(BuildContext context) async {
  File? video;
  try {
    final pickVideo =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickVideo != null) {
      video = File(pickVideo.path);
    } else {
      showSnacbar(ctx: context, content: 'No Video Added');
    }
  } catch (e) {
    print('Error Pick Video $e');
    showSnacbar(ctx: context, content: e.toString());
  }
  return video;
}

pickGif(BuildContext context){
  try {
    
  } catch (e) {
    showSnacbar(ctx: context, content: e.toString());
  }
}
